Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYHUD12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYHUD12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYHUDTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:19:05 -0400
Received: from msr15.hinet.net ([168.95.4.115]:54285 "EHLO msr15.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153AbYHUDTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:19:03 -0400
From: "Chen Pei Chao" <jackie73@ms2.hinet.net>
To: "'David Newall'" <davidn@davidnewall.com>
Cc: <linux-kernel@vger.kernel.org>, <jackie.chen@foxconn.com>
Subject: =?windows-1255?Q?Re:_Is_there_linux_RAM_filesystem_with_a_fixed_amount_of?=
	=?windows-1255?Q?_memory=3F=FE?=
Date: Thu, 21 Aug 2008 11:16:33 +0800
Message-ID: <01c301c9033c$5e881ef0$4901a8c0@tc.nsbg.efoxconn.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AckDPFAiu0z8TShZTGundBXm5ubX4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Is there any RAM file system that use a fixed amount of memory at all
times
>> and will not grow and shrink dynamically like tmpfs?

>ramfs

I mounted a ramfs filesystem with 10M size, and have a check of
/proc/meminfo.
I find the ramfs also did not have the memory preallocation.

I just add one line into /etc/fstab
none 	/tmp	ramfs	size=10m	0	0 

Any wrong in my steps?

Regards,
Jackie	  	

