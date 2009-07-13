Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZGML5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZGML5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZGML5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:57:00 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:8260 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbZGML47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:56:59 -0400
X-Trace: 225992955/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.11.136/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.11.136
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroBADe9WkpPRQuI/2dsb2JhbAAIywGECQU
X-IronPort-AV: E=Sophos;i="4.42,389,1243810800"; 
   d="scan'208";a="225992955"
Date: Mon, 13 Jul 2009 12:56:17 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, linux-mm@kvack.org,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30] Bad page map in process
In-Reply-To: <Pine.LNX.4.64.0907122151010.13280@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907131236320.20647@sister.anvils>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
 <Pine.LNX.4.64.0907101900570.27223@sister.anvils> <20090712095731.3090ef56@siona>
 <Pine.LNX.4.64.0907122151010.13280@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Guennadi Liakhovetski wrote:
> 
> 2. the specific BUG that I posted originally wasn't very interesting, 
> because it wasn't the first one. Having read a few posts I wasn't quite 
> sure how really severe this BUG was, i.e., whether or not it requiret a 
> reboot. There used to be a message like "reboot is required" around this 
> sort of exceptions, but then it has been removed, so, I thought, it wasn't 
> required any more. But the fact is, that once one such BUG has occurred, 
> new ones will come from various applications and eventually the system 
> will become unusable.

I replaced Bad page state's reboot is needed message by just the BUG
prefix: partly because the bad page handling _is_ now more resilient;
but more because I don't like wasting screenlines which could hold
vital info, and because I didn't see how this BUG differs from others
in whether or not you need a reboot.

A BUG means the kernel is in unknown territory: if you're brave and
want to gather more info, you try to keep on running after a BUG;
if you're cautious, you reboot as soon as possible.

(Hmm, but perhaps I should wire these in to panic_on_oops??)

You did the right thing: kept on running, then decided it wasn't
worth it.  (But you've only sent the one pair of messages gathered:
okay, let's forget the rest until you've sorted the hardware angle.)

Hugh
