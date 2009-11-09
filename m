Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZKIK5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZKIK5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZKIK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:57:46 -0500
Received: from lucidpixels.com ([75.144.35.66]:52785 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZKIK5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:57:46 -0500
Date: Mon, 9 Nov 2009 05:57:51 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, news@phoronix.com
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: Intel DP55KG + Intel Core i7 870 + Phoronix Benchmarks / Turbo
 Boost
In-Reply-To: <alpine.DEB.2.00.0911081638400.25174@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0911090555250.22798@p34.internal.lan>
References: <alpine.DEB.2.00.0911081638400.25174@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Nov 2009, Justin Piszcz wrote:

> Hello,
>
> I performed a bunch of tests with my processor to see if Turbo Boost was
> working correct, the short answer is, it /appears/ to be..

[ .. ]

There is another method to check whether Turbo Boost appears to be working, 
without ACPI_FREQ/etc, I noticed the none of the cores ever went above ~48-50c
for a single threaded application @ 100% CPU.

Now, with ACPI_FREQ+NO_HZ, etc, it is evident that the first core is probably
in Turbo Boost mode, the application being run also seems to indicate this as
it shows a slight increase in performance.

$ sensors
coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +57.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +57.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0002
Adapter: ISA adapter
Core 2:      +41.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0003
Adapter: ISA adapter
Core 3:      +41.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0004
Adapter: ISA adapter
Core 4:      +46.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0005
Adapter: ISA adapter
Core 5:      +46.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0006
Adapter: ISA adapter
Core 6:      +41.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

coretemp-isa-0007
Adapter: ISA adapter
Core 7:      +41.0M-0C  (high = +84.0M-0C, crit = +100.0M-0C)

Justin.

