Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZFBFJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZFBFJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZFBFI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:08:57 -0400
Received: from tundra.namei.org ([65.99.196.166]:58944 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZFBFI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:08:56 -0400
Date: Tue, 2 Jun 2009 15:08:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: lizf@cn.fujitsu.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] TOMOYO: Clarify lock protected section.
In-Reply-To: <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.0906021507360.10061@tundra.namei.org>
References: <200906020143.n521hGGP003698@www262.sakura.ne.jp> <4A248C90.9010904@cn.fujitsu.com> <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Tetsuo Handa wrote:

> I intended to help reviewers to visualize the range of protected section
> at a glance. But if reviewers feel noisy, I can remove these markers.

The lock functions act as annotations, you don't need to add any more.  

Only add comments if the code is not obvious, but also first ask whether 
this might mean that there's something wrong.

-- 
James Morris
<jmorris@namei.org>
