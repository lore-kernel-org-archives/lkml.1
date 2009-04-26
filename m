Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZDZJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZDZJtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZDZJtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:49:11 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44516 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZDZJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=nD3ilSALmme+vzh/U1iPuFy3aCpSgOkfdqiUrAakDwj6Oxbk/jhefFAQjKV6t5Sj+P
         LCm5Zn6cCbsV9uG0F5/cyDxaw6pcOfo4CifujEzD1Qv6QTO58ZyGpgJ7aIb1B1maNfgb
         vgnGoXE9MzMfFk9I+n3hU5As5vMOBUQoiD5yc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
Date: Sun, 26 Apr 2009 11:39:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200904251509.11912.bzolnier@gmail.com> <49F3D994.7020304@kernel.org>
In-Reply-To: <49F3D994.7020304@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904261139.33492.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009 05:48:36 Tejun Heo wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
> > so there is no need for the driver to depend on ATA and SCSI.
> > 
> > Cc: unsik Kim <donari75@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Ah.. right, that's a rather large dependency to pull in just for the
> string functions.  Yeah, I think it would be better to keep local
> copy at elast for now.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> (Continuing from the previous message :-) or do you want me to fold
> these patches into my series and push them through Jens with other
> patches?

Please include them in your series if possible.  Thanks!
