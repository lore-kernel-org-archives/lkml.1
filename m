Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZCRMKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZCRMKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZCRMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:10:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:38423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbZCRMKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:10:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,384,1233561600"; 
   d="scan'208";a="395481465"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Date: Wed, 18 Mar 2009 12:09:52 +0000
Subject: RE: [PATCH] dmaengine: Add Kconfig of DMA data align for DMA Test
 	driver
Thread-Topic: [PATCH] dmaengine: Add Kconfig of DMA data align for DMA Test
 	driver
Thread-Index: AcmmgvNnemIwkSonTFuwL0qq68OVBABP2UFg
Message-ID: <129600E5E5FB004392DDC3FB599660D786B0DFC5@irsmsx504.ger.corp.intel.com>
References: <49B8AC11.70902@renesas.com>
 <e9c3a7c20903161502x4738db4drc9e3abae782e4364@mail.gmail.com>
In-Reply-To: <e9c3a7c20903161502x4738db4drc9e3abae782e4364@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Wed, Mar 11, 2009 at 11:30 PM, Nobuhiro Iwamatsu
> <iwamatsu.nobuhiro@renesas.com> wrote:
>> Test drivers of DMA engine usually perform DMA transfer by 1 byte
>> unit. This can set transfer size of DMA and aligns data for tests.
>> 
>> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
>> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
>> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> ---
> 
> This should just be a module parameter, and it needs error handling
> for the alignment > transfer length case.
> 
> Thanks,
> Dan

I agree with Dan. Align size should be rather module parameter.

Regards,
Maciej