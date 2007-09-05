Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXIEOEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXIEOEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXIEOEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:04:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:54528 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbXIEOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uoMxrUXT95sOZZ8FxnQkc3gXPg2xB2PiVLyN/9vbsFvzZ9p9R/5BHpjmLE2WKxBLnl2zQsE5vy4z3b3lcig2sT4jei4O+UThTm5UtxIGF3Nyut5T+hyJIi+lEReyLKuyJDQmEwguNGFb7Ekp5K3lFZeXuQ6S4ygWacd3VSK8vsU=
Message-ID: <d00698fb0709050704j1014b87al20cfb451ac609e81@mail.gmail.com>
Date: Wed, 5 Sep 2007 16:04:13 +0200
From: noah <noah123@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Rescanning SCSI/SATA bus
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <yq1zm01l0co.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr>
	 <yq1zm01l0co.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/5, Martin K. Petersen <martin.petersen@oracle.com>:
> >>>>> "Jan" == Jan Engelhardt <jengelh@computergmbh.de> writes:
>
> Jan> 11:40 sun:../scsi_host/host0 # echo 1 >scan
> Jan> -bash: echo: write error: Invalid argument
>
> Jan> What is the proper way to trigger a rescan, if it comes to be
> Jan> necessary?
>
> echo "- - -" > scan
>

This doesn't appear to work either (2.6.22, sata_nv).
# find /sys -name scan
/sys/module/scsi_mod/parameters/scan
/sys/class/scsi_host/host9/scan
/sys/class/scsi_host/host8/scan
/sys/class/scsi_host/host7/scan
/sys/class/scsi_host/host6/scan
/sys/class/scsi_host/host5/scan
/sys/class/scsi_host/host4/scan
/sys/class/scsi_host/host3/scan
/sys/class/scsi_host/host2/scan
/sys/class/scsi_host/host1/scan
/sys/class/scsi_host/host0/scan

# echo --- > /sys/class/scsi_host/host9/scan
-bash: echo: write error: Invalid argument

# echo --- > /sys/module/scsi_mod/parameters/scan
-bash: /sys/module/scsi_mod/parameters/scan: Permission denied

  -- noah
