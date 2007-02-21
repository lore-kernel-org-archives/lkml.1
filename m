Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXBUNi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXBUNi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161237AbXBUNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:38:26 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:58338 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161228AbXBUNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:38:24 -0500
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       linux-s390@vger.kernel.org, hpa@zytor.com
Subject: [RFC] [PATCH 0/2] s390: SCSI dump kernel and userspace application
Date: Wed, 21 Feb 2007 14:39:44 +0100
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211439.44821.holzheu@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

s390 machines (z900 or higher) provide hardware support for creating Linux
dumps on SCSI disks. Our current implementation consists of a userspace
application running on an special Linux dump kernel, which exploits the
s390 hardware support. Since both parts (kernel and userspace) belong
together, we would like to put the application code in the Linux source tree
under "arch/s390". Currently we have a dependency on the libc of the
target system. Klibc would be a nice solution for that. Are there currently
any plans for upstream klibc?

* Patch 2 implements the kernel support (zcore character device)
* Patch 3 implements the userspace part, which resides in arch/s390

For more information please refer to Documentation/s390/zfcpdump.txt,
which is contained in patch 2.
