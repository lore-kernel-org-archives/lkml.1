Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZDMLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZDMLh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDMLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 07:37:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZDMLhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 07:37:11 -0400
Message-ID: <49E323E1.90907@garzik.org>
Date: Mon, 13 Apr 2009 07:37:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: jimyeh98@acard.com
CC: jason wu <jason_wu@acard.com>,
       =?UTF-8?B?IuiOiuaWh+iIiShKYXNvbiBDaHVh?= =?UTF-8?B?bmcpIg==?= 
	<jason@acard.com>,
       =?UTF-8?B?IumZs+WKm+iqoChSaWNoYXI=?= =?UTF-8?B?ZCBDaGVuKSI=?= 
	<rchern@acard.com>,
       =?UTF-8?B?Iue/geiMguizgChEYQ==?= =?UTF-8?B?bmllbCBXZW5nKSI=?= 
	<dweng@acard.com>,
       =?UTF-8?B?IuWQs+S9s+eSiyg=?= =?UTF-8?B?TGF1cmVuY2UgV3UpIg==?= 
	<laurence@acard.com>,
       =?UTF-8?B?IumZs+W+tw==?= =?UTF-8?B?5aiBKERlcndlaSBDaGVuKSI=?= 
	<derwei@acard.com>,
       =?UTF-8?B?IumZsw==?= =?UTF-8?B?6YeR5riFKEdlaW5nQ2hpbmcgQ2hlbiki?= 
	<geingching@acard.com>,
       =?UTF-8?B?IueroOeip+WxryhUZXJyeSBDaGFuZyki?= <terryc@acard.com>,
       =?UTF-8?B?IuWKieengOiIiFxcKEphbWVzIExpdVxcKSI=?= 
	<jamesliu@acard.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: Fw: [PATCH] ahci: add ACard 8620 support (rough draft)
References: <000d01c9b815$73006700$b500a8c0@JasonWuNB> <49E31219.1000301@acard.com>
In-Reply-To: <49E31219.1000301@acard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Yeh wrote:
> Dear Jeff,
> 
> This is Jim,an IC PM from ACARD Technology. Thanks for your effort on 
> building Linux driver for ACARD ATP8620. Since ACARD already have a 
> verified AHCI driver for ATP8620, we'd like to submit this one for the 
> kernel built-in driver (please see attachment). This driver support 
> Linux Kernel 2.6.29 AHCI mode for ATP8620 (2ch SATA IC) and ATP8624 (4ch 
> SATA IC). It already passed our own stability and compatibility test 
> with SATA devices like HDD, ODD, or PortMultiplier. If you have any 
> question or need the hardware for testing, please don't hesitate to 
> contact me. Thanks again for your help.

Thank you for your email.

We understand you have verified your driver, but it is standard Linux 
driver policy to avoid code duplication.  Multiple implementations of 
AHCI drivers implies several negative factors:

* each bug fix must be reviewed across multiple AHCI drivers, to 
determine if the bug fix must be copied

* non-uniform user experience, depending on AHCI platform

* Shared AHCI code gets much more testing and verification.

* When a hardware vendor's AHCI chip reaches End Of Life, or the company 
goes out of business, users are not abandoned.

So, for the official Linux kernel drivers that are shipped by Red Hat, 
Novell/SuSE, Canonical and other vendors, we will need to modify the 
existing Linux AHCI driver to support ATP8620 and ATP8624.


And yes -- test hardware would be greatly appreciated!  If you could 
send these, that would be appreciated:

	To Tejun Heo
	------------
	1 x ATP8620
	1 x ATP8624

	To Jeff Garzik
	--------------
	1 x ATP8620
	1 x ATP8624

I assume this is PCI, PCI-X or PCI-Express form factor?

Regards and thanks,

	Jeff




