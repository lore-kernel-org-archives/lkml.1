Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZF3X52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZF3X52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZF3X5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:57:21 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3111 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZF3X5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:57:21 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Scott Branden" <sbranden@broadcom.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jun 2009 16:57:13 -0700
Subject: RE: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn52kNGWbjeWRx9QNWAYoGnXdAPhgAAokUQ
Message-ID: <9383297B60843144AC17878B479520F1109EEFC25D@SJEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665479D00EG14815220-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

We would really like to know what needs to change in our patchset.  We have a large codebase of drivers for multiple chipsets already written that we have been maintaining internally and releasing for customer development.  For code that patches existing linux code we follow the style dictated in those files.  But for our new code we do not.

For our new code we have many developers who have written the code and thus a few "linux standard" coding styles have not been followed.  Much driver code is split into an os-less portion and a linux wrapper portion.  People have written following ISO/IEC 9899:1999 coding which allows such things as // comments.  Also using tabs in our code is not a requirement.  

My question is do we need to change our entire codebase over to match linux coding standards for comments and whitespace so it can pass a checkpatch script?  I'm sure there is a standard linux kernel community response to this but I need to forward that answer (whatever it is) to our many developers so we know what it is required to get our existing code integrated into the standard linux kernel.

Thanks,
 Scott


-----Original Message-----
From: linux-arm-kernel-bounces@lists.arm.linux.org.uk [mailto:linux-arm-kernel-bounces@lists.arm.linux.org.uk] On Behalf Of Alan Cox
Sent: June 30, 2009 4:21 PM
To: Jean-Christophe PLAGNIOL-VILLARD
Cc: Leo (Hao) Chen; linux-arm-kernel@lists.arm.linux.org.uk; Linux Kernel
Subject: Re: [PATCH v1 6/6][ARM] new ARM SoC support: BCMRing

On Tue, 30 Jun 2009 20:41:01 +0200
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> On 16:30 Fri 26 Jun     , Leo (Hao) Chen wrote:
> > Hi,
> > 
> > The last patch. This big patch includes the minimal set of our CSP (chip support package), which is our OS independent chip supporting code and headers.  All the codes are under arch/arm/mach-bcmring directory.
> This patch is unreadable
> you need
> 1) Respect the Linux coding Style

For an OS independant set of chip support defines that usually makes no sense

> 2) to split in small changeset

For a new submission that generally doesn't make much sense either - not for all the new files stuff.


-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php


