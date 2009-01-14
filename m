Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZANTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZANTTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZANTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:18:56 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:48148 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbZANTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:18:55 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
To: Evgeniy Polyakov <zbr@ioremap.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 14 Jan 2009 20:18:49 +0100
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Mon, Jan 12, 2009 at 03:51:08PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk)

>> > Well, Kenny has to die, but if we still decide to change the world, here
>> > is the fist step.
>> 
>> NAK this entire thing - we have an existing interface that does the job
>> far better.
> 
> Mwahaha, I just checked how scores are calculated, so that userspace
> could adjust them. Let's start with beginning:

[snip]

> Do you _REALLY_ think anyone can calculate it yourself and then properly
> calculate adjustment used to properly select oom-killed process?

That's easy: Just let your Kenny process run, and check it's score. If it's
too low, increase the adjustment until it's just above the other processes'
score. Using binary search, you're done in five steps.

Then, while you're at it, protect the important programs by setting
their adjustment to -17.

