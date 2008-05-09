Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYEIXib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYEIXib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYEIXiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:38:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:64957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983AbYEIXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OwLTnQhsj0DNHMh/ZZyicLIo5XtTyq19R1ZJZtZ3BJP0Uud34kbBLOEkuBFDqUt2oZamBabLeO+z7ZiOqkpojq3QUvW3/LffOGWiF5Jb4Z8oYCT4+gEAyYFJ7Y3ydij8RXvXCTnfQj4JA05qcetVn97bo2us6SPshnpNYtO1eIA=
Message-ID: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
Date: Fri, 9 May 2008 16:38:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Greg KH" <greg@kroah.com>
Subject: lsscsi is broken
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LBSuse:~ # lsscsi
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
[target0:0:0]type?   vendor?  model?           rev?  -
[target1:0:0]type?   vendor?  model?           rev?  -
[target2:0:0]type?   vendor?  model?           rev?  -
[target3:0:0]type?   vendor?  model?           rev?  -
[target6:0:0]type?   vendor?  model?           rev?  -
[target7:0:0]type?   vendor?  model?           rev?  -
[target8:0:0]type?   vendor?  model?           rev?  -
[target9:0:0]type?   vendor?  model?           rev?  -
[target12:0:0]type?   vendor?  model?           rev?  -
[0:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[1:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[2:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[3:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[6:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[7:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[8:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[9:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[12:0:0:0]   cd/dvd  TSSTcorp CD/DVDW TS-T632A SR03  -


Linux LBSuse 2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty
#372 SMP Thu May 8 18:54:33 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux
