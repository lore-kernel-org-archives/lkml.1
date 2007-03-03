Return-Path: <linux-kernel-owner+w=401wt.eu-S2992864AbXCCBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992864AbXCCBXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992831AbXCCBXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:23:32 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:3415 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992862AbXCCBXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=jpaMaoE88DnhHecwEfW1TUW/Vthu6BYlJTCNQimRM+EtQfb0DQG6n7X7nBoGn/PgmomDCJ4jUJo6ydaO+DIxzCCzFdfadoNGA1DjIHnJlHdV3i8F2AxBdd+yRFllALfJzfOLhaNCRNbbPcEB03rPB6QNTFlwKG50cfVvCAWXX+Q=
Message-ID: <41b516cb0703021723s40ca2f4es6d200f7ced7aaffd@mail.gmail.com>
Date: Fri, 2 Mar 2007 17:23:29 -0800
From: "Chris Leech" <christopher.leech@intel.com>
Reply-To: chris.leech@gmail.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] I/OAT fixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e2b313223d074f47
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from git://lost.foo-projects.org/~cleech/linux-2.6#master

A few drivers/dma and related I/OAT fixes, and missing documentation.
These have been posted for review and sitting in MM for a while now.

- Chris

Andrew Morton (1):
      I/OAT: warning fix

Chris Leech (6):
      ioatdma: Push pending transactions to hardware more frequently
      ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
      ioatdma: Remove the use of writeq from the ioatdma driver
      I/OAT: Add documentation for the tcp_dma_copybreak sysctl
      I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
      I/OAT: Only offload copies for TCP when there will be a context switch

Dan Aloni (1):
      I/OAT: fix I/OAT for kexec

Jeff Garzik (1):
      drivers/dma: handle sysfs errors

  Documentation/networking/ip-sysctl.txt |    6 +
 MAINTAINERS                            |   12 +++
  drivers/dma/dmaengine.c                |   22 +++++-
  drivers/dma/ioatdma.c                  |   81 ++++++++++++----------
  drivers/dma/ioatdma_io.h               |  118
---------------------------------
  net/ipv4/tcp.c                         |   26 +++++--
 6 files changed, 100 insertions(+), 165 deletions(-)
