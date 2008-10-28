Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYJ1UVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYJ1UVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYJ1UUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:20:44 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44172 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753685AbYJ1UUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:20:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ng2kd+ZPXJkJRLUZ0PXwgqq0RHcQtKrwuKccSCConaOOAYKwcRStnc3vnEWkl2rDBbOI24QO0DBO0XwwHs9MTIRFx8+AezyPYYtDMn3HpxT8nnYEBgNZ1fLBn/lk0ykXLGuJYI/+EreU2K0HE4FAo/vJGAHN/65uN/wC8kDlTSA=  ;
X-YMail-OSG: EymZkbMVM1l8CIe7zgIM91X86DGmi8_oSHshen1ERncTISWgnSJJ7zqvbHfLLyqzbkDYXHKLTU7.WGMI6wIl5NzTnYF4BZ1UfY2PleiF7ZDErJ2m1FNVZL3s02ebVW4jVeI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Andrew Victor" <avictor.za@gmail.com>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Date: Tue, 28 Oct 2008 12:51:29 -0700
User-Agent: KMail/1.9.10
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>
References: <200810271406.24110.david-b@pacbell.net> <200810280920.19864.david-b@pacbell.net> <cd73a99e0810281141ief64433u85a55d045346d3fd@mail.gmail.com>
In-Reply-To: <cd73a99e0810281141ief64433u85a55d045346d3fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281251.30031.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Andrew Victor wrote:
> hi David,
> 
> > I verified it on AT91, where the console is normally DBGU and the
> > other USARTs do get an open().
> 
> The DBGU is part of the system peripherals, which are clocked from MCK
> and which is always enabled.

Exactly.


> Therefore I don't think this is a valid test-case.

Not for the oddball case Haavard mentioned, no:  the console port
being something the boot loader wasn't using, which couldn't show
the early boot messages (before console setup) in any case.  Those
kinds of systems aren't especially debuggable (it's JTAG or nothing).

I don't have any issue with getting that fixed too ... but unless
someone has a platform that relies on that case (or can be made to
do so, for testing), then it's hard for me to worry about it!

- Dave


> 
> Regards,
>   Andrew Victor
> 
> 


