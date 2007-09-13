Return-Path: <linux-kernel-owner+w=401wt.eu-S1763129AbXIMQOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763129AbXIMQOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbXIMQOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:14:17 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:39471 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXIMQOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:14:16 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/3] IB/ehca: MR/MW fixes
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 13 Sep 2007 18:14:13 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200709131814.13937.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset replaces Nam's previous MR/MW patch (posted by me). I split
the #define fixes into a separate patch and moved the "is the memory from
hugetlbfs?" code into ib_umem_get().

[1/3] fixes the page size HW cap defines
[2/3] adds the hugetlb test to ib_umem_get()
[3/3] finally uses the hugetlb flag in ehca_reg_user_mr()

The patches should apply cleanly, in order, on top of my previous 12-patch
set. Please review the changes and apply the patches for 2.6.24 if they are
okay.

Regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com



