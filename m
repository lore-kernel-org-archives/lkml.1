Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYGEXzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYGEXzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYGEXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:55:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:10858 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYGEXzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:55:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,308,1212390000"; 
   d="scan'208";a="405677556"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/2 V2] MMC: cleanup endianity conversions and style problems
Date: Sun, 6 Jul 2008 02:54:56 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F80104198D56@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20080706012631.5e43624c@mjolnir.drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2 V2] MMC: cleanup endianity conversions and style problems
Thread-Index: Acje9paKC4xe14pRQ86VCvUqQHcrZgAAVQSg
References: <1215276725-15588-1-git-send-email-tomas.winkler@intel.com><1215276725-15588-2-git-send-email-tomas.winkler@intel.com> <20080706012631.5e43624c@mjolnir.drzeus.cx>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: <marcel@holtmann.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Jul 2008 23:55:05.0827 (UTC) FILETIME=[8C5EC330:01C8DEFA]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-list@drzeus.cx]
>Sent: Sunday, July 06, 2008 2:27 AM
>To: Winkler, Tomas
>Cc: marcel@holtmann.org; linux-kernel@vger.kernel.org; Winkler, Tomas
>Subject: Re: [PATCH 2/2 V2] MMC: cleanup endianity conversions and
style
>problems
>
>On Sat,  5 Jul 2008 19:52:05 +0300
>Tomas Winkler <tomas.winkler@intel.com> wrote:
>
>> This patch cleans up endianity conversions im mmc core
>> and style errors in the 'for' statements
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>
>NAK in its current form. The data needs to be DMA:able, which means
>that the stack cannot be used.
>
I see, anyway only the last hunk is problematic in this matter.
 
So we need to define raw_src as __be32 and translate it in
mmc_decode_src 
I will get to the MMC spec only tomorrow but it sound strange that SDIO
registers are in little endian and these are in big.
Thanks
Tomas



---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

