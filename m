Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYDZQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYDZQMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYDZQMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:12:43 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:36111 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754057AbYDZQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:12:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fV2zIfw1J/h0jtJ9jQMD4k0ocxbQ/yD6rdp7x8lsvnmFYFAqWz51/nLXYpPSfmFm31EopR0WCOMZWJDf/zrKwapfKZhdf1z9C6+u8AUK5lII3Y2J8majDynXju0Bf33BEGcUArEbEI8p31OD9sYKaIQpx5YTh8KF13h78pIoZC8=  ;
X-YMail-OSG: WHcZBIEVM1lvtU.F76sdD_ePkMzwYPEOHSOucbR7I48NtEZZ2yy59rHxWpuQg9jxssoQ.w1PuGfi15CUjqkNUM5zknNuNjr.o3SpoATyBMD3SzaPR2fro5Itb5kPo9H9ZhE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] Give gpiolib an implementation of gpio_is_valid()
Date: Sat, 26 Apr 2008 09:12:39 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <1209207781.3756.120.camel@moss.renham>
In-Reply-To: <1209207781.3756.120.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804260912.39970.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008, Ben Nizette wrote:
> Platforms which use generic (NOP) gpio routines get an implementation of
> gpio_is_valid() (in linux/gpio.h) but the people who actually use gpio
> don't get one.  Roll an implementation for gpiolib based on
> gpio_request(); this ought to do for most people.

There's already a gpio_is_valid() patch in the MM merge queue;
it comes with the documentation, and covers implementations which
include the <asm-generic/gpio.h> header (for cansleep stubs) but
don't use gpiolib.

So, please wait till RC1, by which time I expect Andrew's queue
will be relatively depleted.  :)

- Dave
