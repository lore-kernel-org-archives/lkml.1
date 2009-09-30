Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZI3Pzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZI3Pzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZI3Pzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:55:51 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:36094 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810AbZI3Pzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:55:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=dx4hE1GOdCA/lugjLTy7WHuTGeHTggz+GU+NOF1Y8E2dIgyMvr7TINnXGrR/u6rV;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <3664891.1254326154501.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Wed, 30 Sep 2009 11:55:54 -0400 (EDT)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: newer non-distro kernels don't boot / unpack?
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb00ff6c36d42eb1fa14b8613bf22062b2f0e0b821d28e6d0c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so after removing rhgb and quiet from the menu.lst
for this kernel the last few messages it prints are:

sdb:
sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
XFS mounting filesystem sda3
VFS: Mounted root (xfs filesystem) readonly on device 8:3.
Freeing unused kernel memory: 416k freed
Warning: unable to open an initial console.

Since it does not seem to be reaching the init stage but
does seem to be finding the disks and mounting the filesystems
it is getting much further along than I thought. I guess
I have a problem with the console/terminal parts of the
kernel compile/configuration.


-----Original Message-----
>From: Arjan van de Ven <arjan@infradead.org>
>Sent: Sep 30, 2009 11:47 AM
>To: "Steven A. DuChene" <linux-clusters@mindspring.com>
>Subject: Re: newer non-distro kernels don't boot / unpack?
>
>first remove rhgb and quiet.. that way you get at least the kernel log
>on the screen... to see where you get stuck.
>
>
>-- 
>Arjan van de Ven 	Intel Open Source Technology Centre
>For development, discussion and tips for power savings, 
>visit http://www.lesswatts.org



