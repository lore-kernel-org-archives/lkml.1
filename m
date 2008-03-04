Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbYCDB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbYCDB3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYCDB3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:29:22 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:47971 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755550AbYCDB3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:29:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IygLSCPR3IobrgonCa/4hKmey2ts/MB7jGmCOZp7NxceK7dOM5JX0DQTubBKWW1gJ6xajyJIT5aJ7V95esyc+ju4QGFlkU+tmx7FVUpD6Gq1x6BXikPxbp0qabdvbxy6wcJlr+RBFS6CdS7wNVX+icHwHmINSUj5dQYjcxOYUr4=  ;
X-YMail-OSG: zrGodwsVM1mfUxy3xGdYifEMbHQlS563js8pe7vGnxpmrvvE0aEXNAdItWgbcS_x5IneroQK7Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Subject: Re: High resolution timers on AT91SAM926x
Date: Mon, 3 Mar 2008 17:29:18 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de
References: <200803011457.40857.david-b@pacbell.net> <200803031039.57909.david-b@pacbell.net> <d6c8ef150803031342r567aab86x776dc2a8b73714b6@mail.gmail.com>
In-Reply-To: <d6c8ef150803031342r567aab86x776dc2a8b73714b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031729.19264.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Bosko Radivojevic wrote:
> I had CONFIG_ATMEL_TCLIB enabled, but not TCB_CLKSRC and
> TCB_CLKSRC_BLOCK=0. With all those options, I finally have HRT
> functionality. But, strange thing is that jitter of my little example
> (get time, sleep 1ms, get time, show the difference) is around 250us.
> Maybe this is normal for this architecture?

I have no idea why that would be.  Maybe you can find out.  :)


> System is (as noted on rt.wik site) very slow with NO_HZ option enabled.

It doesn't exactly say *why* or compare to other arm926ejs
chips ... 

Could the 64-bit math (ktime stuff) be a factor there?  Your
board probably only runs at 95 (or-so) bogomips after all.

And is that just a NO_HZ issue, or generically an issue when
oneshot timer modes are in heavy use?

- Dave
 
