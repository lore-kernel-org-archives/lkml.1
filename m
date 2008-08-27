Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYH0Ulh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYH0Ulh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYH0Ul2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:41:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbYH0Ul1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:41:27 -0400
Date: Wed, 27 Aug 2008 13:40:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Osterlund <petero2@telia.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <m3k5e2qkk2.fsf@telia.com>
Message-ID: <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Peter Osterlund wrote:
> 
> Why not just revert the offending change and try again during the next
> merge window, assuming someone has figured out an acceptable way to
> handle this mess by then?

Well,, for 2.6.27 that's what we'll have to do. But there's actually a 
real problem here - the unlocked ioctl's (which we _should_ prefer) have a 
strictly weaker and worse interface. I also wonder if any other 
block_ioctl users were converted..

Anyway, I'll take your email as an ack for the revert.

		Linus
