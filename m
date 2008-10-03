Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYJCIFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYJCIFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYJCIEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:04:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJCIEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:04:48 -0400
Date: Fri, 3 Oct 2008 10:04:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: clean up x86-64 warnings
Message-ID: <20081003080428.GD25408@elte.hu>
References: <48E55C2B.1060804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E55C2B.1060804@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> There are a couple of Xen features which rely on directly accessing
> per-cpu data via a segment register, which is not yet available on
> x86-64.  In the meantime, just disable direct access to the vcpu info
> structure; this leaves some of the code as dead, but it will come to
> life in time, and the warnings are suppressed.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/enlighten.c  |   61 +++++++--------------------------------------
> arch/x86/xen/xen-asm_64.S |   22 +++++++++++++---
> 2 files changed, 28 insertions(+), 55 deletions(-)

applied to tip/x86/xen, thanks Jeremy!

	Ingo
