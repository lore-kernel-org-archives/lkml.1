Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYKYUpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYKYUpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKYUoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:44:55 -0500
Received: from buick.jordet.net ([193.91.240.190]:54496 "EHLO buick.jordet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYKYUoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:44:54 -0500
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
In-Reply-To: <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
References: <1226760254.5089.11.camel@chevrolet>
	 <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	 <1227476908.32357.5.camel@chevrolet>
	 <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	 <1227485956.5145.10.camel@chevrolet>
	 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
	 <1227569808.5039.6.camel@chevrolet>
	 <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 21:44:47 +0100
Message-Id: <1227645887.7992.10.camel@chevrolet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ti., 25.11.2008 kl. 01.09 +0100, skrev Sven-Haegar Koch:
> I had the same problem when I tried it on my laptop (T60) - using it on 
> the unencrypted root filesystem (with /usr/src) took ages, using it on 
> the LUKS encrypted /home was blasing fast - on the same disk.
> 
> This test was some time ago with something like 2.6.20 or 2.6.24 - I 
> gave up and reformatted / with ext3 as I needed the machine.
> 
> I think barriers were the problem, they seem to cost performance like 
> hell, especially for operations with many small files. My laptop used 
> barriers for xfs on the direct partition, but not on crypto drivermapper 
> mounts.
> 
> So perhaps try mounting with nobarrier and see if the speed problem goes 
> away - but know that you sacrifice some crash-resilience when doing so.

Barriers were the problem indeed. My old system had no problems with
barriers, but here it did an incredible difference.

Thanks!
-Stian

