Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbXKCXan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbXKCXan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbXKCXaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:30:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbXKCXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:30:35 -0400
Message-ID: <472D0488.7040404@zytor.com>
Date: Sat, 03 Nov 2007 16:30:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: x86_64 ten times slower than i386
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
In-Reply-To: <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bo Brantén wrote:
> On Sat, 3 Nov 2007, Matt Mackall wrote:
> 
>> This is typically due to a problem with the setup of your MTRRs. Try
>> booting with mem=nnnM where nnn is some number smaller than your
>> actual amount of memory.
> 
> Thank you for that advice, the system has 4GB and if I boot with 
> mem=3072M it will run as fast as normal while if I don't use the mem 
> option it will run 10 times slower, however if I use a figure like 
> mem=3500M the kernel will panic, is there any way to determine the 
> highest usable figure without try and error?

Yes, look at how your MTRRs are set up (cat /proc/mtrr).

	-hpa
