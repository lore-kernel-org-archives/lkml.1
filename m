Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZF3XzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZF3XzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZF3XzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:55:03 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2728 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZF3XzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:55:01 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Tue, 30 Jun 2009 16:54:50 -0700
Subject: RE: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn53PeQVNuAfDN0RrGuuOXKKJCh0AAAKVFg
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1BA7@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C7@SJEXCHCCR02.corp.ad.broadcom.com>
 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
 <20090630184101.GI23292@game.jcrosoft.org>
 <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
 <20090630233737.GS23292@game.jcrosoft.org>
In-Reply-To: <20090630233737.GS23292@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66547A474CG14607686-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 

> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com] 
> Sent: Tuesday, June 30, 2009 4:38 PM
> To: Alan Cox
> Cc: Leo (Hao) Chen; linux-arm-kernel@lists.arm.linux.org.uk; 
> Linux Kernel
> Subject: Re: [PATCH v1 6/6][ARM] new ARM SoC support: BCMRing
> 
> On 00:20 Wed 01 Jul     , Alan Cox wrote:
> > On Tue, 30 Jun 2009 20:41:01 +0200
> > Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> > 
> > > On 16:30 Fri 26 Jun     , Leo (Hao) Chen wrote:
> > > > Hi,
> > > > 
> > > > The last patch. This big patch includes the minimal set 
> of our CSP (chip support package), which is our OS 
> independent chip supporting code and headers.  All the codes 
> are under arch/arm/mach-bcmring directory.
> > > This patch is unreadable
> > > you need
> > > 1) Respect the Linux coding Style
> > 
> > For an OS independant set of chip support defines that 
> usually makes no
> > sense
> here it's really unreadable
> IMHO as you will have to rewrite it to use the kernel API so 
> it make sense

I am fixing the coding style errors reported by the checkpatch.pl script. So that they should be more readable to kernel developers.

> > 
> > > 2) to split in small changeset
> > 
> > For a new submission that generally doesn't make much sense 
> either - not
> > for all the new files stuff.
> here you have mixed timer, dma, irq, clock, and other new 
> files in the same
> patch, it's really hard to follow the patch. Split it a few 
> will be easier
> to review IMHO
> 

I am trying to split the patch into smaller patches with block level code.

> Best Regards,
> J.
> 

Thanks for your input,

Leo Chen
Software Engineer
Broadcom Canada Inc.

