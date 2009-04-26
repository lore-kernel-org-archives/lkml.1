Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZDZJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZDZJth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZDZJtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:49:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34652 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZDZJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fE3wE/VMabHfFdrVpTzibrPB0MEu92uaclqLiH4KBsT4FvzLnELogUV6u+Y9dbLENQ
         n+9RbfbrXso9BgIQILPOwOnVaQPe7zEILbZgSDQUeNGhwx9JO/zkrDf4iIiAlL5JqF64
         DxGgZzjRGG6XPTRBAjXajr1LLB+jALveq8ryk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
Date: Sun, 26 Apr 2009 11:53:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: unsik Kim <donari75@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <200904251509.11912.bzolnier@gmail.com> <49F3DD4F.6080804@garzik.org>
In-Reply-To: <49F3DD4F.6080804@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904261153.48230.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009 06:04:31 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
> > so there is no need for the driver to depend on ATA and SCSI.
> > 
> > Cc: unsik Kim <donari75@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/block/Kconfig   |    2 +-
> >  drivers/block/mg_disk.c |   44 ++++++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 41 insertions(+), 5 deletions(-)
> 
> Please CC these types of patches to linux-ide also, as it is of interest 
> to Linux ATA folks...  thanks.

Aye, aye.  I usually do... ;)
