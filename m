Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXJPPWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXJPPWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXJPPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:22:38 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42905 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbXJPPWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:22:37 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/5] IB/ehca: SRQ and MR/MW fixes
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Tue, 16 Oct 2007 17:22:28 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200710161722.29144.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more fixes for the eHCA driver, fixing some problems we found
during internal system test.

[1/5] fixes the QP pointer determination for SRQ base QPs
[2/5] fixes a masking error in {,re}reg_phys_mr()
[3/5] fixes a bug in alloc_fmr() and simplifies some code
[4/5] refactors hca_cap_mr_pgsize and fixes a problem with ib_srp
[5/5] enables large page MRs by default

I built the patches on top of Roland's for-2.6.24 git branch. Please review
and queue them for 2.6.24-rc1 if you're okay with them. Thanks!

Cheers,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com





