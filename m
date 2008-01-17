Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYAQOCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYAQOCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAQOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:02:37 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:63677 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYAQOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:02:36 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/4] IB/ehca: fixes, port connectivity autodetection, problem workaround
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 17 Jan 2008 15:02:33 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801171502.34287.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset will fix a minor issue, introduce port connectivity
autodetection and work around an RDMA-related problem in eHCA2.

[1/4] fixes an error path in destroy_qp()
[2/4] stores the SMI/GSI QPs in a per-port array
[3/4] adds port connectivity autodetection
[4/4] adds the aforementioned workaround

The patches will apply, in order, on top of Roland's for-2.6.25 branch.
Please review them and apply for 2.6.25 if you think they're okay.

Thanks and regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com


