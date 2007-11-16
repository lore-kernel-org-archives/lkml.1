Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbXKPT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbXKPT0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933155AbXKPTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:22:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764960AbXKPTWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:22:41 -0500
Date: Fri, 16 Nov 2007 11:22:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
In-Reply-To: <473DEC1C.8080506@goop.org>
Message-ID: <alpine.LFD.0.9999.0711161118160.4260@woody.linux-foundation.org>
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org> <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org> <473DEC1C.8080506@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Nov 2007, Jeremy Fitzhardinge wrote:
> 
> If you happened to do a 1G munmap, it may end up freeing and 
> reallocating them, but that's going to be very rare.

I don't think we ever free the pmd's now, do we?

(Except for the *final* free, of course, when we release the whole VM).

		Linus
