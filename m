Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbXGXTnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbXGXTnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXGXTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:42:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXGXTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:42:57 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	<20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	<46A578A1.5010504@yahoo.com.au>
	<Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
	<46A5A929.4020706@yahoo.com.au>
	<Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
	<alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jul 2007 22:37:43 +0200
In-Reply-To: <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
Message-ID: <p73myxlsfl4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> (Yes, the "asm volatile" may do so too, but it's very unclear what the 
> "volatile" on the asm actually does, so ..)

Without the volatile they get completely optimized away :/
[tried that, cost a lot of debugging time -- empty string functions
cause a lot of strange side effects]

-Andi
