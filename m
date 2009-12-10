Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbZLJLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbZLJLI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbZLJLIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:08:25 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:37530 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZLJLIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:08:24 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device mapper warnings
Date: Thu, 10 Dec 2009 12:08:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-release; KDE/4.3.2; i686; ; )
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
In-Reply-To: <20091209220749.GD8742@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912101208.26510.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 09 Dezember 2009 23:07:49 schrieb Jens Axboe:
> > > > device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
[...]
> Does this work?
[...]
> +#if 0
>  	if (offset &&
>  	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
>  		t->discard_misaligned = 1;
>  		ret = -1;
>  	}
> +#endif

Yes it does. 
