Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbXGWUmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbXGWUmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934394AbXGWUlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:41:52 -0400
Received: from gw.goop.org ([64.81.55.164]:34428 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765029AbXGWUlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:41:51 -0400
Message-ID: <46A51254.8000508@goop.org>
Date: Mon, 23 Jul 2007 13:40:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in> <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in> <46A4E7E3.8090105@goop.org> <Pi <46A4F360.2000905@goop.org> <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> gcc also tries to count the number of instructions, to guess how large in
> bytes the asm block is, as it could make a difference for near vs short
> jumps, etc.
>   

How does it do that?  By looking for \n, ';', etc?

    J
