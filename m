Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXD0ClP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXD0ClP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXD0ClP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:41:15 -0400
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:23670 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751555AbXD0ClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:41:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zzE+j0EGjeXkModKgPmlvRrcmrdHEYhj8OcZkPc6IljCeItbjuZWw7kWHbWutlYXiTBwCAehC5pdcgXOfIXbALWsUOaGcZEXTRjId55/lkNGHqeKGwlPUDdZt7ZOym7/6VuhCnTvCPAnXN4SH3Ovw0HdGb9r1gedqvMDS8B3SBI=  ;
Message-ID: <20070427024113.677.qmail@web36702.mail.mud.yahoo.com>
X-YMail-OSG: zAUbiToVM1lxXxm3NGVID46Zp2hvpIOkeM_zcoW7na6YRhgbFN0bxwwtckypT478i5FmXuMhK2S15kS6jcojM2fMxsoKQ6vb.Rv_79JfpaFgTOG6l41QDXzmQ0zcKQ--
Date: Thu, 26 Apr 2007 19:41:13 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Sergey Yanovich <ynvich@gmail.com>
In-Reply-To: <4630486C.4020900@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> Sergey Yanovich wrote:
> > 
> > I have found it easier to rewrite the driver, than to fix.
> 
> Before you get your hopes up, this development model is not one that will get
> your code merged upstream. You should really try to work with Alex, not side
> step him. Drivers are rarely complex enough to warrant, or even have room for, a
> rewrite. And judging from your code it looks more like reorganising the code
> that's already there.

It is a sad truth. Instead of raising real issues that may remain in the driver, I was presented
with "non-proof" that bus-adapter-device architecture I'm using is somehow bad and the driver
should be turned into a monolithic blob, using config variables to disable unneeded functionality.
Considering, that udev handles automatic loading of the drivers just fine (so it's not an end user
issue at any rate), I don't see any justification for the change.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
