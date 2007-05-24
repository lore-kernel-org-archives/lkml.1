Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbXEXBYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbXEXBYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbXEXBYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:24:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:3439 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760807AbXEXBYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sxjGt/jB46OwzU1VlUh7QghjJh/HbnGNCXEH+5meDApeQ9/bw7WMBV9YiF/sZcaHr10Ryu9y+f6bHK+jXqThF4/Mo9Bim3NPPFYUdmLtaYAIBiCPIAcUxCnyTCp7gVHDLnME7b6QbWs5VU+cT9ozKFjmzP7Fwe3DRrQCW8ijsZc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Junio C Hamano <junkio@cox.net>
Subject: Re: [PATCH] Match DMA blacklist entries between ide-dma.c and libata-core.c
Date: Thu, 24 May 2007 02:19:05 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
References: <20070521145042.GA6957@redhat.com> <20070521171551.0f81a0be@the-village.bc.nu> <7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
In-Reply-To: <7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240219.06328.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007, Junio C Hamano wrote:
> There are a few entries in ata_device_blacklist[] in libata-core.c
> marked with HORKAGE_NODMA but are missing from drive_blacklist[]
> in ide-dma.c.  This patch makes the lists in sync.
> 
> Also remove a duplicated entry for "SanDisk SDP3B-64".
> 
> Signed-off-by: Junio C Hamano <junkio@cox.net>

applied
