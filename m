Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXBWP0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXBWP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbXBWP0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:26:48 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:42901 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbXBWP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:26:47 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 23 Feb 2007 10:23:46 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Allexio Ju <allexio.ju@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: trivial question regarding byte ordering
In-Reply-To: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702231022400.7312@CPE00045a9c397f-CM001225dbafb6>
References: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Allexio Ju wrote:

> Hi,
>
> Is there a API (or macro) that checks CPU endianness and does byte
> ordering conversion on given data (32-bit) if endianness is
> big-endian?

#include <asm/byteorder.h>

each architecture is responsible for including the appropriate header
file for either big or little endianness.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
