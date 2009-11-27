Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZK0XaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZK0XaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZK0XaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:30:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:40311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZK0XaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:30:04 -0500
Date: Sat, 28 Nov 2009 00:30:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alex Custov <alex.custov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: touchscreen wirh 2.6.26
In-Reply-To: <39840bc80911270936n2cb568e6wd33a376ab59a6e62@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911280025460.6953@wotan.suse.de>
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>  <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>  <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>  <alpine.LSU.2.00.0911271308270.6953@wotan.suse.de>
 <39840bc80911270936n2cb568e6wd33a376ab59a6e62@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Alex Custov wrote:

> Bus 004 Device 002: ID 0408:3000 Quanta Computer, Inc.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0408 Quanta Computer, Inc.
>   idProduct          0x3000

Unfortunately, this touchscreen is not (yet) neither supported by 
usbtouchscreen kernel driver, nor is it apparently HID standard compliant, 
so HID driver can't do much with it as well.

You will have to reverse-engineer the data protocol the touchscreen is 
sending. It's usually quite easy, in cases in which the device doesn't 
require complex initialization before it can become functional.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
