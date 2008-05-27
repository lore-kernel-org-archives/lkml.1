Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYE0UT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYE0UT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYE0UTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:20 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63886 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756067AbYE0UTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:19 -0400
Date: Tue, 27 May 2008 21:18:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
In-Reply-To: <Pine.LNX.4.55.0805212036320.4894@cliff.in.clinika.pl>
Message-ID: <Pine.LNX.4.55.0805271910130.18833@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805212036320.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Maciej W. Rozycki wrote:

>  Some systems incorrectly report the ExtINTA pin of the I/O APIC as the
> genuine target of the timer interrupt.  Here is a change that copies timer
> pin information found to the other pin if one has been found only.  This 
> way both a direct and a through-8259A route is tested with the pin letting 
> these problematic systems work well enough.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> patch-2.6.26-rc1-20080505-timer-pins-0

 Please withdraw this patch only.  I shall follow with a replacement
series straight away.  Please apply patches in the order of submission.  
You should end up with 15 patches from both series combined.  Unless a 
problem is reported I think this concludes the work required for the timer 
for now.

  Maciej
