Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZAIXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZAIXLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZAIXLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:11:34 -0500
Received: from alpha.facton.com ([83.236.152.122]:40492 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZAIXLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:11:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: Fw: hwinfo problem since 2.6.28
Date: Sat, 10 Jan 2009 00:09:54 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD13C73ECC@exch.facton.local>
In-Reply-To: <20090109222552.GB6472@linux-os.sc.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: Fw: hwinfo problem since 2.6.28
Thread-Index: AclyqUbUaPQ+OdaOQDiNsb4IamVQRQABeO+A
References: <20090108015424.e9443521.akpm@linux-foundation.org> <20090108112543.GA25606@elte.hu> <20090109222552.GB6472@linux-os.sc.intel.com>
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <spender@grsecurity.net>, <pageexec@freemail.hu>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Since 2.6.28 my hwinfo tool crashes badly on 2 years old 
> OpenSuSE 10.2
> > > x64/SMP.
> > > Older kernels run fine, I did a "make oldconfig" and rather used
> > > defaults (just skipping low-64k checks).
> > > This seems to be the only affected binary as far I can see.
> > > Did I miss a new legacy/compat option or is it a bug?
> > > 
> > > Thank you!
> > > Daniel
> > > 
> > > hwinfo: Corrupted page table at address 7fd04de3ec00
> > > PGD 7dc33067 PUD 3efe067 PMD 27b83067 PTE fffffffffffffbff
> > > Bad pagetable: 000d [#9] SMP
> 
> Daniel, Can you please check and ack if the appended patch fixes this
> page table corruption issue? We tried to reproduce your issue
> locally here but didn't succeed because of different hwinfo versions.
> 
> thanks,
> suresh
> ---

Works great! hwinfo runs fine again.

Thank you!
Daniel
