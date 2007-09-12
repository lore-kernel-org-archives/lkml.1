Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbXILQKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbXILQKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764705AbXILQJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:09:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758263AbXILQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:09:56 -0400
Date: Wed, 12 Sep 2007 09:09:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: akpm@linux-foundation.org, Tony Breeds <tony@bakeyournoodle.com>,
       Michael Neuling <mikey@neuling.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@redhat.com>,
       davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
In-Reply-To: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.0.999.0709120908090.16478@woody.linux-foundation.org>
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, Paul Mackerras wrote:
> 
> Linus, this seems a bit cleaner than putting ifdefs in
> drivers/char/tty_ioctl.c, and it fixes the compile error on powerpc.
> Your choice whether to use this patch or Tony's.

Yeah, I'll take this one. I just wanted to understand why it triggered at 
all.

Andrew - I'm dropping Tony's patch you forwarded, but since it will still 
apply cleanly, you should drop it manually from your queues.

		Linus
