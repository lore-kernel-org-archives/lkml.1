Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXDYDkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXDYDkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 23:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXDYDkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 23:40:19 -0400
Received: from nofear-snat.bivio.net ([216.142.75.231]:55957 "EHLO
	corpexc01.corp.networkrobots.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753729AbXDYDkR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 23:40:17 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 23:40:17 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Ramdisk Vs NFS
Date: Tue, 24 Apr 2007 20:27:23 -0700
Message-ID: <D83235F0F3C86D4D889D8B9A0DA8C6D762CA83@corpexc01.corp.networkrobots.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Ramdisk Vs NFS
Thread-Index: AceG6aO/OsP/xp17Rb+KAuUZY7SZDw==
From: "Siva Prasad" <sprasad@bivio.net>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

What is the primary difference between Ramdisk and NFS with respect to
the wait_queue's?

If I use ramdisk, every thing works fine, but with NFS (or you may read
as 'no ramdisk') kernel/sched.c:__wake_up_common() routines has a
problem. Basically the value of "&q->task_list->next" is out of our
memory range (not between 0xc0000000 and 0xF0000000), and this causes
trouble of accessing non-existing memory. Why would this happen?

Interesting thing is, this happens much before we even load the ramdisk
drivers.

Appreciate if any one has some insight into this. At least a pointer to
where to start looking would be great.

Thanks
Siva

