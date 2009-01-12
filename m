Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZALE7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZALE7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 23:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZALE7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 23:59:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:47972 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZALE7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jGfZDSyiAG/I/13rFf70yOBlHUt6HNRJ3nKWc4X6fMzlL0cIG68+sKkokhkuYTDPci
         X+4conESQMAmh7uazCXXnUXtCTcHqSzj6RI3OdfwgR/n6RqQad/bvfAVrT2dc1ztlADH
         SxvvE87KaVQILDhA3AzgVKmAs699m59f8pzuk=
Message-ID: <a0e7fce50901112059u6ac9bb6duba38795aa85f854c@mail.gmail.com>
Date: Mon, 12 Jan 2009 12:59:13 +0800
From: "yi li" <liyi.dev@gmail.com>
To: "Nifty niftylinkern Mitch" <niftylinkern@niftyegg.com>
Subject: Re: [BUG] MMC/SD: SDHC card capacity not correct
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
In-Reply-To: <20090111204852.GA3869@compegg.wr.niftyegg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
	 <20090111204852.GA3869@compegg.wr.niftyegg.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 4:48 AM, Nifty niftylinkern Mitch
<niftylinkern@niftyegg.com> wrote:
>
> Check the partition map.  I see one partition smaller than the SD card.
> Compare /dev/mmcblk0 and /dev/mmcblk0p1.
> If this is the answer post a follow up to the kernel list that it was solved.
>

Thanks for the response, but what do you mean?
There is only one partition in the partition table, i.e.,
/dev/mmcblk0p1, isn't it?

fdisk /dev/mmcblk0

Command (m for help): p

Disk /dev/mmcblk0: 8068 MB, 8068268032 bytes
249 heads, 62 sectors/track, 1020 cylinders
Units = cylinders of 15438 * 512 = 7904256 bytes

        Device Boot      Start         End      Blocks  Id System
/dev/mmcblk0p1               1        1020     7873349  83 Linux

Command (m for help): x
Expert command (m for help): p
Disk /dev/mmcblk0: 249 heads, 62 sectors, 1020 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl      Start       Size ID
 1 00   1   1    0 248  62 1019         62   15746698 83
 2 00   0   0    0   0   0    0          0          0 00
 3 00   0   0    0   0   0    0          0          0 00
 4 00   0   0    0   0   0    0          0          0 00

-Yi
