Return-Path: <linux-kernel-owner+w=401wt.eu-S1763067AbXF1RTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763067AbXF1RTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbXF1RTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:19:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7014 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbXF1RTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OzWVJNCZ/Xf1M6Vu1wltekFHTNYMmIfnf/HgkDFYXuL9+ugxgIIBTONwNa8tPSEyimezoCSn2uOVPoI9nowMsv63MTg0TRLC1iXvVSI8/JYOkIF/HeFS+yilQEaM9/uKGGOBfKGZCr9wdezsjbq/fisw00oX0MHfKlUhmmdFp6w=
Message-ID: <4376bb340706281019m6c39035ey279fe83af9ae9bc1@mail.gmail.com>
Date: Thu, 28 Jun 2007 10:19:00 -0700
From: "Roy Franz" <roy.lists@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Unable to change sata NCQ depth due to readonly /sys/block/sdc/device/queue_depth file
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I am unable to change the NCQ settings for a sata drive that
supports it - NCQ is always on.  This is due to the sysfs queue_depth
file being read-only.  This is on
vanilla 2.6.21.5 running with Debian Etch.  (Several earlier versions
of the kernel
had this same issue.)  The drive (WD Raptor) is hooked up to a Nvidia
sata controller.

amd64:/# ls -al /sys/block/sdc/device/queue_depth
-r--r--r-- 1 root root 4096 2007-06-28 10:04 /sys/block/sdc/device/queue_depth
amd64:/# cat /sys/block/sdc/device/queue_depth
31
amd64:/#

I searched but did not find any helpful information on this.  Forcing
a change by changing permissions on the file did not work.

Thanks,
Roy
