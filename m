Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbXIKNTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbXIKNTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXIKNTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:19:03 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:57505 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXIKNTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:19:01 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 00/12] IB/ehca: New features and fixes for 2.6.24
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Tue, 11 Sep 2007 15:18:25 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200709111518.26276.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fresh eHCA driver features and fixes for your reviewing
pleasure. They have passed internal testing and checkpatch.pl, so we think
they are ready for inclusion.

[01/12] adds userspace support for small QPs
[02/12] changes a nit in firmware communication
[03/12] adds support for more than 4096 QPs/CQs in user space
[04/12] enables mapping firmware contexts into uspace on 64K-page kernels
[05/12] changes hvCall debug trace formatting
[06/12] outputs return codes as signed decimal integers
[07/12] makes warnings also appear in non-debug mode, like they should
[08/12] replaces get_paca()->paca_index by the portable smp_processor_id()
[09/12] checks the allowed max number of SGEs when creating a QP
[10/12] fixes some Path Migration problems
[11/12] works around a firmware race condition
[12/12] bumps the driver's version number

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches for 2.6.24 if they are okay.

Regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com




