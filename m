Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXKCWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXKCWin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXKCWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:38:36 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:32881 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbXKCWif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:38:35 -0400
Date: Sat, 3 Nov 2007 23:38:24 +0100 (CET)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: linux-kernel@vger.kernel.org
cc: mpm@selenic.com
Subject: Re: x86_64 ten times slower than i386
In-Reply-To: <20071103162640.GS17536@waste.org>
Message-ID: <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
 <20071103162640.GS17536@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Matt Mackall wrote:

> This is typically due to a problem with the setup of your MTRRs. Try
> booting with mem=nnnM where nnn is some number smaller than your
> actual amount of memory.

Thank you for that advice, the system has 4GB and if I boot with mem=3072M 
it will run as fast as normal while if I don't use the mem option it will 
run 10 times slower, however if I use a figure like mem=3500M the kernel 
will panic, is there any way to determine the highest usable figure 
without try and error?
