Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZKJOit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZKJOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZKJOis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:38:48 -0500
Received: from emulex.emulex.com ([138.239.112.1]:61865 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZKJOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:38:47 -0500
Message-ID: <4AF97AF5.2090700@emulex.com>
Date: Tue, 10 Nov 2009 09:38:45 -0500
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] scsi_lib_dma.c :  fix bug with dma maps on nested scsi
 objects - (2nd try)
References: <1257295546.5965.7.camel@wookie> <1257449592.10355.26.camel@mulgrave.site>
In-Reply-To: <1257449592.10355.26.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 14:38:47.0477 (UTC) FILETIME=[82F97E50:01CA6213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

This updated patch works fine for lpfc and our vports...

Acked-By: James Smart  <james.smart@emulex.com>

-- james s


James Bottomley wrote:
> 
> 141 lines plus a static list to solve a simple problem is getting a bit
> icky to say the least.
> 
> What about being more simplistic and simply making the host cache a
> pointer to the physical bus device?  I probably objected to this a long
> time ago because using the parent pointers is more elegant, but I think
> this patch demonstrates conclusively it's not worth this amount of code
> for the sake of alleged elegance.
> 
> James
> 
> ---
>  drivers/scsi/hosts.c            |   13 ++++++++++---
>  drivers/scsi/lpfc/lpfc_init.c   |    2 +-
>  drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
>  drivers/scsi/scsi_lib_dma.c     |    4 ++--
>  include/scsi/scsi_host.h        |   16 +++++++++++++++-
>  5 files changed, 30 insertions(+), 8 deletions(-)

