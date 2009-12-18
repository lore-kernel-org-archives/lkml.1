Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZLROqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZLROqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZLROqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:46:33 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:59512 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZLROqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:46:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Fri, 18 Dec 2009 22:46:27 +0800
Message-ID: <3A45394FD742FA419B760BB8D398F9ED01059523@zch01exm26.fsl.freescale.net>
In-Reply-To: <20091217170958.GE18271@ovro.caltech.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Thread-Index: Acp/O8y33Ql7nvfqQcqjxzDrJBlTmAAtJW/g
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
From: "Li Yang-R58472" <r58472@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Dan Williams" <dan.j.williams@intel.com>
Cc: "Kumar Gala" <galak@kernel.crashing.org>, <herbert@gondor.apana.org.au>,
       "Tabi Timur-B04825" <B04825@freescale.com>,
       <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>,
       "Suresh Vishnu-B05022" <B05022@freescale.com>,
       <linux-crypto@vger.kernel.org>,
       "Dudhat Dipen-B09055" <B09055@freescale.com>,
       "Gupta Maneesh-B18878" <B18878@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for 
>Async_tx XOR offload
>
>On Wed, Dec 16, 2009 at 03:47:48PM -0700, Dan Williams wrote:
>> Kumar Gala wrote:
>> >>> Changes with respect to v1 as per comments received o. 
>Rebased to 
>> >>> linux-next as of 20091216 o. The selection is based exclusive of 
>> >>> fsldma o. Intoduced a new Kernel Configuration variable
>> >>>   *. This enables selecting the Cryptographic functionality
>> >>>      of Talitos along with fsldma.
>> >>>   *. Disables the XOR parity calculation offload, if 
>fsldma enabled
>> >>>      either as kernel in-built or as a module
>> >>>   *. Once the inter-operability with fsldma is resolved, 
>this option
>> >>>      can be removed
>> >> wait, why can't the interoperability bug be fixed in the 
>first place?
>> > 
>> > I agree w/Kim.  We need to better understand what the bug 
>is and how to reproduce it so we can get to the root cause.
>> > 
>> > Paper taping over it by disabling fsldma is not the right solution.
>> 
>> Hopefully this prompts fsldma authors to get involved because the 
>> interoperability issue has been out there without comment*, just 
>> band-aids, since October.
>> 
>> --
>> Dan
>> 
>> * well one comment from Ira saying the interrupt 
>functionality worked 
>> for him.
>
>Yes, I have used the device_prep_dma_interrupt() functionality 
>quite a while back. However, I found it to be pretty much 
>useless. Any functionality I need is covered by adding a 
>callback to the last DMA
>memcpy() operation. Since the operations happen in-order, I 
>can be sure that the entire set of memcpy()s cas completed. I 
>never needed the capability to generate an interrupt without a 
>memcpy().
>
>I agree that the fsldma driver could use some love. There are 
>places where I am still not confident in the locking. Perhaps 
>I can find some time over Christmas to work on it, but I need 
>someone with 85xx/86xx hardware to test the changes. I only 
>have 83xx hardware.

I can also help with the 85xx testing when I finish the busy project
soon.

- Leo
