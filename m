Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXHaOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXHaOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965305AbXHaOC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:02:26 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:54069 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbXHaOCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:02:25 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 0/2] IB/ehca: Fixes for rc5
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Fri, 31 Aug 2007 16:01:41 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200708311601.42220.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix some ehca issues that should be fixed in 2.6.23.

[1/2] fixes regressions caused by the recent addition of Small QPs.
[2/2] adds missing SRQ-related functionality that would have broken IPoIB CM.

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches for 2.6.23-rc5 if they are okay.

Regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com



