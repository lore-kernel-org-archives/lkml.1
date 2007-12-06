Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbXLFTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbXLFTeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXLFTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:34:00 -0500
Received: from outbound.mse3.exchange.ms ([69.25.50.242]:54231 "EHLO
	outbound.mse3.exchange.ms" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXLFTeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:34:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: FW: Guidance on resources for User Space Device Drivers on 2.6 kernel
Date: Thu, 6 Dec 2007 14:33:45 -0500
Message-ID: <32A49E5BEBD67A4F877032926EFAA4D2092CCC84@ms08.mse3.exchange.ms>
In-Reply-To: <47584D8C.4090000@s5r6.in-berlin.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: FW: Guidance on resources for User Space Device Drivers on 2.6 kernel
Thread-Index: Acg4Pk2Na369CSykTnOQPli9wOaYvgAACsUw
References: <32A49E5BEBD67A4F877032926EFAA4D209283BD7@ms08.mse3.exchange.ms> <20071206114912.GL15974@stusta.de> <4757ED3B.1000703@s5r6.in-berlin.de> <32A49E5BEBD67A4F877032926EFAA4D2092CCABF@ms08.mse3.exchange.ms> <47584D8C.4090000@s5r6.in-berlin.de>
From: "Jaursch, Bill" <bjaursch@aeshen.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your point is well taken.

I will probably end of with a system daemon (User Space), but pass
communication via a Kernel module (Kernel Space).  The application can
call the kernel module, passing data back to the daemon (User Space).
Once I have hw, I may just use the kernel module.

Thanks again.

-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de] 
Sent: Thursday, December 06, 2007 11:29 AM
To: Jaursch, Bill
Cc: Adrian Bunk; Leon Woestenberg; linux-kernel@vger.kernel.org
Subject: Re: FW: Guidance on resources for User Space Device Drivers on
2.6 kernel

Jaursch, Bill wrote:
> The reason to even consider a driver for this "Software only" driver
> was to start the work of writing a kernel space driver (loadable
> module).  So more specifically, I wanted to know if there is a way
> to use calls to the kernel to access a loadable module that is
> running code in User Space (to take advantage of libraries, tools,
> prevention of kernel crashes, etc.).

Since you plan to use this for a PCI device eventually, it sounds like
UIO would be of help.

> I am running 2.6.20, so many of the new User Space Driver features
> don't appear to be available (UIO, User Space API, etc.).  And at
> this point I don't expect my end users to upgrade to a newer kernel.

Perhaps you can backport UIO or can get someone to do it for you.
-- 
Stefan Richter
-=====-=-=== ==-- --==-
http://arcgraph.de/sr/
