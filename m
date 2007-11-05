Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXKEU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXKEU1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXKEU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:27:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60806 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXKEU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:27:40 -0500
Message-ID: <472F7CB8.4070809@garzik.org>
Date: Mon, 05 Nov 2007 15:27:36 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Darrick J. Wong" <djwong@us.ibm.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] libsas: Convert sas_proto users to sas_protocol
References: <20071105195117.GB7010@tree.beaverton.ibm.com>
In-Reply-To: <20071105195117.GB7010@tree.beaverton.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Darrick J. Wong wrote:
> sparse complains about the mixing of enums in libsas.  Since the
> underlying numeric values of both enums are the same, combine them
> to get rid of the warning.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/aic94xx/aic94xx_dev.c  |    6 +++---
>  drivers/scsi/aic94xx/aic94xx_dump.c |    4 ++--
>  drivers/scsi/aic94xx/aic94xx_hwi.c  |    2 +-
>  drivers/scsi/aic94xx/aic94xx_scb.c  |    6 +++---
>  drivers/scsi/aic94xx/aic94xx_task.c |   30 +++++++++++++++---------------
>  drivers/scsi/aic94xx/aic94xx_tmf.c  |   12 ++++++------
>  drivers/scsi/libsas/sas_discover.c  |    2 +-
>  drivers/scsi/libsas/sas_expander.c  |    6 +++---
>  drivers/scsi/libsas/sas_internal.h  |    2 +-
>  include/scsi/libsas.h               |   18 +++++++++---------
>  include/scsi/sas.h                  |   13 ++++++-------
>  include/scsi/scsi_transport_sas.h   |    8 +-------
>  12 files changed, 51 insertions(+), 58 deletions(-)

ACK patches 1-2


