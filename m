Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZDXOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZDXOhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZDXOhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:37:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65204 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZDXOhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pu325YUHnC2zLzJfnCJktenhDSvlZ/C8jRwkzy72m5AT0CoD2Tx5jMfg7AI6DEfEPa
         6gg+iplxR0ObM/OIPXjKNXX7z+oe3kqoJq8MMlaR3e0cn0vSk0WAUld5H93XazrosTM9
         P9M4vGJjprFpAJFAqRWs/c6kU6kfz9LJPWAaQ=
MIME-Version: 1.0
In-Reply-To: <49F1B68D.3010304@garzik.org>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
	 <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
	 <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
	 <49F1B68D.3010304@garzik.org>
Date: Fri, 24 Apr 2009 16:37:17 +0200
X-Google-Sender-Auth: 5cc727e9fe75cfef
Message-ID: <ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and 
	partitions
From: Carl Henrik Lunde <chlunde@ping.uio.no>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>,
       rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de,
       James.Bottomley@hansenpartnership.com, dgilbert@interlog.com,
       jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen <martin.petersen@oracle.com> wrote:
> +What:          /sys/block/<disk>/alignment
> +What:          /sys/block/<disk>/<partition>/alignment
> +What:          /sys/block/<disk>/queue/minimum_io_size
> +What:          /sys/block/<disk>/queue/optimal_io_size

Would it also be possible and useful to include the number of
spindles/channels, i.e., how many requests the device can handle
concurrently?  CFQ could for example serve two time slices
concurrently if you have sequential reads and the device reports two
spindles.

[sorry for replying in the middle of the thread, but I didn't get the
original email]
-- 
mvh
Carl Henrik
