Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZFBCa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZFBCa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZFBCat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:30:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55144 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbZFBCas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:30:48 -0400
Message-Id: <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
Subject: Re: [PATCH 2/5] TOMOYO: Clarify lock protected section.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: lizf@cn.fujitsu.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 11:30:45 +0900
References: <200906020143.n521hGGP003698@www262.sakura.ne.jp> <4A248C90.9010904@cn.fujitsu.com>
In-Reply-To: <4A248C90.9010904@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 01062009 #2072025, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Tetsuo Handa wrote:
> > Enclose reader section in
> > 	/***** READER SECTION START *****/
> > and
> > 	/***** READER SECTION END *****/
> > and writer section in
> > 	/***** WRITER SECTION START *****/
> > and
> > 	/***** WRITER SECTION END *****/
> > in order to avoid oversighting lock protected section.
> > 
> 
> This makes me a bit uncomfortable..
> 
> IMHO this seems ugly, useless, and even harmful. If it's helpful,
> we'd be doing this for the whole kernel tree, which is crazy..
> 
> Or does tomoyo do this for it's special reason?

I intended to help reviewers to visualize the range of protected section
at a glance. But if reviewers feel noisy, I can remove these markers.

Thanks.
