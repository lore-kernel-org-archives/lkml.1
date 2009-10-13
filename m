Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbZJMX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbZJMX5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbZJMX5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:57:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:55250 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761696AbZJMX5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:57:31 -0400
Date: Tue, 13 Oct 2009 19:56:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: nut-upsuser@lists.alioth.debian.org
cc: linux-kernel@vger.kernel.org
Subject: Re: USB/UPS connectivity issue on Intel DP55KG Motherboard
In-Reply-To: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910131956390.29143@p34.internal.lan>
References: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Justin Piszcz wrote:

> Hello,
>
> I use the following in my ups.conf:
>
> # USB:
> [apc]
>  driver = usbhid-ups
>  port = auto
>  desc = "APC 1500VA"
>  pollfreq = 5
>
> On my new motherboard (an Intel DP55KG), every once and awhile I get this:
>
> Broadcast Message from nut@box.com
>        (somewhere) at 17:48 ...
>
> Communications with UPS apc@localhost lost
>
>
> Broadcast Message from nut@box.com
>        (somewhere) at 17:48 ...
>
> Communications with UPS apc@localhost established
>
> On my previous motherboard (a DG965WH), the exact same configuration was used
> and I never had this issue.
>
> Any hints?
>
> Should I increase the pollfreq to say 30 seconds?
>
> Would this 'workaround' the problem?
>
> Is this a known bug on this chipset?
>
> Justin.
>
>
>

More logs:

Oct 13 18:01:46 p34 upsd[7338]: Data for UPS [apc] is stale - check driver
Oct 13 18:01:46 p34 upsmon[7342]: Poll UPS [apc@localhost] failed - Data stale
Oct 13 18:01:46 p34 upsmon[7342]: Communications with UPS apc@localhost lost
Oct 13 18:01:50 p34 upsd[7338]: UPS [apc] data is no longer stale
Oct 13 18:01:51 p34 upsmon[7342]: Communications with UPS apc@localhost established
Oct 13 18:02:48 p34 upsd[7338]: Data for UPS [apc] is stale - check driver
Oct 13 18:02:51 p34 upsmon[7342]: Poll UPS [apc@localhost] failed - Data stale
Oct 13 18:02:51 p34 upsmon[7342]: Communications with UPS apc@localhost lost
Oct 13 18:02:52 p34 upsd[7338]: UPS [apc] data is no longer stale
Oct 13 18:02:56 p34 upsmon[7342]: Communications with UPS apc@localhost established

Justin.


