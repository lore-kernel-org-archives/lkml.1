Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZAZOSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZAZOSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZAZOSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:18:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZAZOSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:18:38 -0500
Date: Mon, 26 Jan 2009 15:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Fix __per_cpu_load relocation
Message-ID: <20090126141832.GA31442@elte.hu>
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232977445-11815-1-git-send-email-brgerst@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> This patch fixes this error:
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load
> 
> Now, __per_cpu_load is a section-relative symbol:
> c0aa4000 D __per_cpu_load
> c0aa4000 A __per_cpu_load_abs
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Applied to tip/core/percpu, thanks Brian!

	Ingo
