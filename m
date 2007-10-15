Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXJOVfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXJOVfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXJOVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:35:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:43251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbXJOVfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,278,1188802800"; 
   d="scan'208";a="299216180"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23]ata_piix: SATA 2port controller port map fix
Date: Mon, 15 Oct 2007 14:33:55 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701DCDDBE@orsmsx420.amr.corp.intel.com>
In-Reply-To: <4713C21E.5060000@pobox.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23]ata_piix: SATA 2port controller port map fix
Thread-Index: AcgPYz1AxGcErqv2SJClE/lvoQbjawABjA2g
References: <200710111605.15757.jason.d.gaston@intel.com> <4713C21E.5060000@pobox.com>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <htejun@gmail.com>
X-OriginalArrivalTime: 15 Oct 2007 21:33:57.0604 (UTC) FILETIME=[17DC7A40:01C80F73]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>this was full of spaces, and should be converted to tabs (I did this
>manually)
>
>In the future, make sure to run your patch through
>scripts/checkpatch.pl.  Some of that script's complaints are a bit
>insane, but most are good.
>
>>  static const struct piix_map_db *piix_map_db_table[] = {
>>  	[ich5_sata]		= &ich5_map_db,
>>  	[ich6_sata]		= &ich6_map_db,
>> @@ -463,6 +476,7 @@
>>  	[ich6m_sata_ahci]	= &ich6m_map_db,
>>  	[ich8_sata_ahci]	= &ich8_map_db,
>>  	[tolapai_sata_ahci]	= &tolapai_map_db,
>> +	[ich9_2port_sata]	= &ich9_2port_map_db,
>>  };
>>
>>  static struct ata_port_info piix_port_info[] = {
>> @@ -587,6 +601,17 @@
>>  		.udma_mask	= ATA_UDMA6,
>>  		.port_ops	= &piix_sata_ops,
>>  	},
>> +
>> +	/* ich9_2port_sata: 12: */
>
>changed this to
>
>	[ich9_2port_sata] =
>
>since we have started using the (C99? gcc?) method of initializing
>piix_port_info[] array entries based on the given index, rather than
>simply noting the index in a comment and depending on the order of
other
>entries not to change.
>
>	Jeff

Thank you Jeff!  I guess it is time to switch email clients, as this one
keeps trashing my file import.  I thought I had it worked out, guess
not.  

Thanks again,

Jason
