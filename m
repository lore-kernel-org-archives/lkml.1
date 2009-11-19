Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbZKSKx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbZKSKx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZKSKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:53:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55094 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZKSKx0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:53:26 -0500
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: David Miller <davem@davemloft.net>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Nov 2009 02:51:55 -0800
Subject: RE: linux-next: net tree build failure
Thread-Topic: linux-next: net tree build failure
Thread-Index: AcpoHX4HQJ/EFMPCQ9yK87n2L6QlcAA6ND3W
Message-ID: <89E2752CFA8EC044846EB8499819134101737DBD7C@EXCH-MBX-4.vmware.com>
References: <20091118165145.d0c3114b.sfr@canb.auug.org.au>,<20091117.230530.108140449.davem@davemloft.net>
In-Reply-To: <20091117.230530.108140449.davem@davemloft.net>
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

________________________________________
From: David Miller [davem@davemloft.net]
Sent: Tuesday, November 17, 2009 11:05 PM
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Shreyas Bhatewara
Subject: Re: linux-next: net tree build failure

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Nov 2009 16:51:45 +1100

> drivers/net/vmxnet3/vmxnet3_drv.c: In function 'vmxnet3_prepare_tso':
> drivers/net/vmxnet3/vmxnet3_drv.c:826: error: implicit declaration of function 'csum_ipv6_magic'
>
> Revealed by commit 115924b6bdc7cc6bf7da5b933b09281e1f4e17a9 ("net:
> Getting rid of the x86 dependency to built vmxnet3") which allowed this
> driver to be built on PowerPC at all.

Enabling on more platforms helps find problems like this :-)

> Subject: [PATCH] net: using csum_ipv6_magic requires including net/ip6_checksum.h
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks!




Thanks Stephen,

I cross-compiled the patched kernel for sparc. Didn't do it for PowerPC :(

->Shreyas