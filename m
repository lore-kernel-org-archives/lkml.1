Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZI3RjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZI3RjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZI3RjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:39:00 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:59779 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbZI3RjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:39:00 -0400
X-Greylist: delayed 2020 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 13:39:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=Ln6DwBNkJs/Noj+AgAFhPOosznK7eg2SEzXBQjDLxehyZSAtuDgCcCv35PGvuODL;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <31532395.1254330324879.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Wed, 30 Sep 2009 13:05:24 -0400 (EDT)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: linux-kernel@vger.kernel.org
Subject: Warning: unable to open an initial console
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb00ff6c36d42eb1fa7f4e5aef82e600c430c42262c8810425350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I tried various combonations of turning off the framebuffer
support all together and then turning it back on with various
drivers (nvidia or vesa vga) but still I get the same message
about "Warning: unable to open an initial console."

Anything else I should be looking at besides the graphics support
part of the drivers section of the kernel config?

Again this is a fairly standard PCChips A13G motherboard with
NVidia chipset and AMD Athlon 3600+ CPU that works fine with the
regular distro supplied FC9 kernel (2.6.25-14.fc9.x86_64) and
I have the x86_64 version of FC9 installed.

-----Original Message-----
>From: "Steven A. DuChene" <linux-clusters@mindspring.com>
>Sent: Sep 30, 2009 11:55 AM
>To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
>Subject: Re: newer non-distro kernels don't boot / unpack?
>
>OK, so after removing rhgb and quiet from the menu.lst
>for this kernel the last few messages it prints are:
>
>sdb:
>sdb1 sdb2
>sd 1:0:0:0: [sdb] Attached SCSI disk
>XFS mounting filesystem sda3
>VFS: Mounted root (xfs filesystem) readonly on device 8:3.
>Freeing unused kernel memory: 416k freed
>Warning: unable to open an initial console.
>
>Since it does not seem to be reaching the init stage but
>does seem to be finding the disks and mounting the filesystems
>it is getting much further along than I thought. I guess
>I have a problem with the console/terminal parts of the
>kernel compile/configuration.
>
>
>-----Original Message-----
>>From: Arjan van de Ven <arjan@infradead.org>
>>Sent: Sep 30, 2009 11:47 AM
>>To: "Steven A. DuChene" <linux-clusters@mindspring.com>
>>Subject: Re: newer non-distro kernels don't boot / unpack?
>>
>>first remove rhgb and quiet.. that way you get at least the kernel log
>>on the screen... to see where you get stuck.
>>
>>
>>-- 
>>Arjan van de Ven 	Intel Open Source Technology Centre
>>For development, discussion and tips for power savings, 
>>visit http://www.lesswatts.org
>
>



