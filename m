Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbXGINCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbXGINCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXGINC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:02:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:12280 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXGINCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:02:25 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 00/13] IB/ehca: eHCA2 enablement & some fixes
Date: Mon, 9 Jul 2007 15:02:21 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200707091502.22407.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables the eHCA device driver to support new functions of
the eHCA2 chip. In addition, there are some bug fixes, code optimizations
and general new features included. Another set of patches will follow.

The patches, in detail, are:

[01/13] fixes a wrong parameter description
[02/13] adds HW capabilities autodetection
[03/13] restructures the QP code, preparing for Share Receive Queues (SRQ)
[04/13] adds SRQ support
[05/13] adds support for UD low latency QPs
[06/13] sets a flag that needs to be set on eHCA2
[07/13] adds RDMA atomic attributes to the data returned by query_qp()
[08/13] straightens out lock flag naming and adds static initializers
[09/13] refactors synchronization between completions and destroy_cq()
[10/13] changes the global idr spinlocks into rwlocks
[11/13] returns the QP pointer in poll_cq() instead of NULL
[12/13] adds notifications in case the SM LID etc. changes
[13/13] adds a slight latency improvement

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches for 2.6.23 if they are okay.

Regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com

