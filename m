Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZAMAFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZAMAFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAMAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:05:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:37395 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZAMAFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:05:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,255,1231142400"; 
   d="scan'208";a="481089168"
From: "Love, Robert W" <robert.w.love@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Jan 2009 17:05:00 -0700
Subject: RE: [PATCH -next] libfc: needs CRC32
Thread-Topic: [PATCH -next] libfc: needs CRC32
Thread-Index: Acl05tXnal+L2OrASZe0zzXqVZ3zTAAK5WQA
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B28A124F4@azsmsx505.amr.corp.intel.com>
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
 <496B9112.8070908@oracle.com>
In-Reply-To: <496B9112.8070908@oracle.com>
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

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libfc uses crc32 functions, so cause it to be built
> via select:
> 
> drivers/built-in.o: In function `fc_frame_crc_check':
> (.text+0x75dae): undefined reference to `crc32_le'
> drivers/built-in.o: In function `fc_fcp_recv':
> fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Robert Love <robert.w.love@intel.com>

> ---
>  drivers/scsi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090112.orig/drivers/scsi/Kconfig
> +++ linux-next-20090112/drivers/scsi/Kconfig
> @@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS
> +	select CRC32
>  	---help---
>  	  Fibre Channel library module
> 
> 
> --
> ~Randy

