Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbYBBRvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbYBBRvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYBBRvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:51:36 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:39067 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751528AbYBBRvg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:51:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bR8BNhVo2pyismG5f8GIESSrbo0fcKRoenj7wD6JLYFUn8piE1V7y67DnEHIgLzfJo1P0pxXf9iHRVIsBFIbULZF3sSq9ma49tPOKAj9K6nL9q9fPh1MRF74lG4XtUzAldcXO1Log42RD08n6Il1btbICCpX2EYx+EaALsMUq3U=  ;
X-YMail-OSG: gCJZRK0VM1kfk4YPch12LnqifXjVF0imxxPKWUnadgRFJhr3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 09:49:22 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202124759.GB25773@elf.ucw.cz> <20080202135037.GC925@elte.hu>
In-Reply-To: <20080202135037.GC925@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802020949.23397.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Ingo Molnar wrote:
> 
> i'd really love to have a /dev/rtc device compatibility APIs, both 
> inside and outside the kernel.

Unfortunately the /dev/rtc code became a legacy API for good reasons.

Like not recognizing that all the world's not a PC, with a single RTC
that clones a long-obsolete chip from Motorola ... and not having been
specified in a hardware-neutral manner.  Oh, and of course not all
systems actually used the same RTC driver anyway; it's not like there
was just *one* such programming interface to worry about.


> I really dont know why the new RTC code  
> does not do it - why does it put up artificial anti-adoption barriers to 
> make it harder to migrate to the new code?

What "anti-adoption" barriers would those be?  Pavel's immediate
problem was easy to solve, though he didn't know it.

>From the perspective of almost anyone not using a PC, all the
adoption barriers were on the side of the /dev/rtc code.

- Dave
