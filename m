Return-Path: <linux-kernel-owner+w=401wt.eu-S1767317AbXECCQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767317AbXECCQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767329AbXECCQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:16:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767317AbXECCQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:16:17 -0400
Message-ID: <463945DC.1020701@zytor.com>
Date: Wed, 02 May 2007 19:15:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Martin Mares <mj@ucw.cz>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <46369B03.1060500@zytor.com> <mj+md-20070502.074425.20911.nikam@ucw.cz> <200705021122.20716.ak@suse.de>
In-Reply-To: <200705021122.20716.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I agree; that code can all go.
> 
> What also seems to miss are the early CPUID checks I recently added
> and which x86-64 has for some time.
> 

I probably need to rebase against your tree.  It makes more sense, anyway.

Either way, I just added a pretty decent framework for testing the CPU
features and barfing if they're missing.

> Also if you ever add x86-64 support it does an additional BIOS
> call to tell the BIOS it is 64bit.

Added.

	-hpa


