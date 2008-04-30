Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbYD3SGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbYD3SGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYD3SFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:05:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64379 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757656AbYD3SFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:05:30 -0400
Date: Wed, 30 Apr 2008 19:05:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Timur Alperovich <timur.alperovich@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: APIC error 80(80) and 00(80)
In-Reply-To: <52950c3f0804301018n7dd2a803h4abce71b0dcacf3d@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0804301858240.31832@cliff.in.clinika.pl>
References: <52950c3f0804301018n7dd2a803h4abce71b0dcacf3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Timur Alperovich wrote:

> I apologize if others have asked this question before, but I'm a bit
> confused by the APIC error messages, i.e. I couldn't find what they

 It sounds strange -- the errors are explained in the source next to the 
message you are seeing.

> mean. After inserting a kernel module I wrote and trying to read the
> device it created, I see the following in dmesg:
> 
> Losing some ticks... checking if CPU frequency changed.
> warning: many lost ticks.
> Your time source seems to be instable or some driver is hogging interupts
> rip tg3_read32+0x9/0xa [tg3]
> Falling back to HPET
> APIC error on CPU3: 00(80)
> APIC error on CPU3: 80(80)
> 
> where the last message was repeated 1600 times. Could anyone tell me
> what it means or of a better place to ask about it?

 This is "Illegal register address", which means some piece of code tried
to access an inexistent APIC register.  If you want to find out where the
code is, then trigger an oops from where the message is printed.  Of
course it looks like the tip of an iceberg anyway...

  Maciej
