Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbXJ2Qr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbXJ2Qr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ2Qrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:47:51 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:61690 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXJ2Qru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:47:50 -0400
Date: Mon, 29 Oct 2007 17:47:03 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Andries Brouwer <aeb@cwi.nl>, Al Viro <viro@ftp.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071029174703.5e3cbff2@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071029154849.GA24187@bigserver.hohndel.org>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com>
	<20071029154849.GA24187@bigserver.hohndel.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 08:48:49 -0700,
Dirk Hohndel <hohndel@linux.intel.com> wrote:

> [PATCH] add_partition silently ignored errors
> 
> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
> 
> ---
>  block/ioctl.c         |    5 ++++-
>  fs/partitions/check.c |   30 ++++++++++++++++++++++++------
>  include/linux/genhd.h |    2 +-
>  3 files changed, 29 insertions(+), 8 deletions(-)

The kobject stuff looks sane to me now. Others will have to comment on
the return code propagation.
