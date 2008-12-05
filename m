Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYLEN01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYLEN01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYLEN0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:26:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:49252 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbYLEN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yF82acQ/j2lDyKMFHG07YRBGKoJK5GkMzIkQdOLX3Cpicy9tem/cVz1ClGLcsca677
         hBrQNksYA1/OeondeUXB/Y5k0OGqVqpdOt3hNRN5+SM97B9D4lGvN/MXt75mDOgLwwzn
         w187ySRhMEhHMAL3+RJM3zEBHulJ9TsvLk8BI=
From: crquan@gmail.com
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mpt fusion: updated mpt drivers from lsi upstream "4.00.43.00"
Date: Fri,  5 Dec 2008 21:26:49 +0800
Message-Id: <1228483610-18502-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

Occasionally I'm working with LSI SAS 1068E controllers on 2.6.26.2 kernel,
it has a nasty bug that some hotplugged disks cannot be auto discovered,
the detailed description is on bugzilla.kernel:

http://bugzilla.kernel.org/show_bug.cgi?id=12163

After some inspecting the vendor's website, I found there are "4.00.43.00"
drivers for RHEL5.1, but the drivers in main stream kernel are still "3.04.07",
and the changelogs of "4.00.43.00" have records on solving that BUG,

but the default "4.00.43.00" downloaded from lsi.com cannot even build on
kernel-2.6.26.2, and after some work, I get it run on 2.6.26.2, then can build
with mainstream git kernel (the HEAD currently),

http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_ics/lsisas1068e/index.html

   -#define MPT_LINUX_VERSION_COMMON	"3.04.07"
   +#define MPT_LINUX_VERSION_COMMON	"4.00.43.00"

This patch is just the upstream "4.00.43.00", it's very big, about 130K after
bzip2'ed, so I upload it to bugzilla.kernel, can now be downloaded from

http://bugzilla.kernel.org/attachment.cgi?id=19155

You can also download the tarball from the vendor's website and
extract them into drivers/, instead of applying this patch.

the next one is the adjusting for mainstream git kernel.

Signed-off-by: LSI Corparation <lsi@lsi.com>
Signed-off-by: Cheng Renquan <crquan@gmail.com>
