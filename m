Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYGJSTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYGJSTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbYGJSS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:18:58 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:34425 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbYGJSS5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:18:57 -0400
From: Frans Pop <elendil@planet.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed using 'upx'
Date: Thu, 10 Jul 2008 20:18:51 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <200807100655.00857.elendil@planet.nl> <alpine.LFD.1.10.0807101015010.11076@woody.linux-foundation.org> <48764BA5.7050104@zytor.com>
In-Reply-To: <48764BA5.7050104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200807102018.53147.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2008 18:18:55.0589 (UTC) FILETIME=[6A097150:01C8E2B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008, H. Peter Anvin wrote:
> The issue with UPX is that UPX actually wants to replace the kernel
> decompressor, which also does other tasks (relocation and ELF parsing)
> in recent kernels.

It does save us about 5% though, which is quite substantial when you're 
talking about fitting a kernel on a boot floppy. For the past few kernel 
versions it has made the difference between being able to base 
installation floppies on the standard Debian kernel (generic 486 flavor) 
or having to come up with radical new solutions.

>From my tests for this issue it looks like .26 has grown so much that 
we've now reached that point anyway though :-(

Cheers,
FJP
