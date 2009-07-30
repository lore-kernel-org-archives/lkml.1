Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZG3NQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZG3NQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZG3NQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:16:40 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26975
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751492AbZG3NQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:16:39 -0400
Message-ID: <4A719D2D.8070001@panasas.com>
Date: Thu, 30 Jul 2009 16:16:29 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com> <20090730093600.GB11381@redhat.com>
In-Reply-To: <20090730093600.GB11381@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 13:16:32.0057 (UTC) FILETIME=[F4AFEA90:01CA1117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2009 12:36 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
>> []$ ls /usr/include/scsi
>> scsi.h
>> scsi_ioctl.h
>> scsi_tgt_if.h
>> sg.h
> 
> $wget http://ftp.gnu.org/gnu/glibc/glibc-2.10.1.tar.bz2
> $cd glibc-2.10.1
> $find . -name scsi
> ./sysdeps/unix/sysv/linux/scsi
> $ls ./sysdeps/unix/sysv/linux/scsi/
> scsi.h  scsi_ioctl.h  sg.h
> 
> where did you get scsi_tgt_if.h?

You're right I have it from the SCSI target framework (tgt)
(http://stgt.berlios.de/)

It is a Kernel header that should be exported, I'll send a
patch to export it.

Thanks
Boaz
