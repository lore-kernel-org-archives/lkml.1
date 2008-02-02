Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbYBBTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbYBBTNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbYBBTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:13:25 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44432 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753870AbYBBTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:13:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rr4k0ZGbknYpVZpknkkqXne+Y7+bTSO+9dg5Tn3XHs8xgGsk9p4j0Yp5/wngw+ANiZ9P2SnxjBNKPLyTL/YUGYY8tb5eJ1yt03otS0aXyTCk/kqA1jJrQQbasf4a2p1ku1rvQuCuuBX2ypihdN23ynKVlLBoHkYzxSmUz4uwePU=  ;
X-YMail-OSG: gR.GyCcVM1mORX5FpsBIKBkWubuMt0nq8ETc9ZMgoKtxLC.79DJ5inu_ZpcKu86_L3bZpFPImg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 11:13:21 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net> <20080202180002.GB26560@elte.hu>
In-Reply-To: <20080202180002.GB26560@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021113.22130.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Ingo Molnar wrote:
>
> > > Yep, you are right, but that is the easy issue to fix.
> > 
> > Which is why I was puzzled that you didn't start out doing it the 
> > "right" way ... even just hard-wiring the dubious assumption that 
> > "rtc0" is the right RTC to use.  :)
> 
> because this was mostly about an quick & easy hack to see whether it 
> makes sense at all to automate the testing of suspend/resume.

I think you should have written "quick and dirty".  ;)

It would have been easier to just use the public interface
and hard-wire "rtc0".  But going directly to the hardware
was dirtier, and more in the spirit of "hack that obviously
shouldn't go upstream until it gets done properly".

- Dave
