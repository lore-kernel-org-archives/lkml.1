Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXKBNdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXKBNdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXKBNcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:32:54 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51116 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXKBNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:32:53 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 0/2] IB/ehca: Return physical link information, fix static rate calculation
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Fri, 2 Nov 2007 15:32:49 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711021432.50203.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset will fix static rate calculation for the new link speeds
supported by eHCA2. Also, it enables query_port() to return physical link
information instead of constant values, which is needed for the static rate
fix.

[1/2] makes query_port() return actual physical link info where supported
[2/2] fixes static rate calculation based on that info

The patches will apply, in order, on top of Roland's for-2.6.24 branch.
Please review them and apply for 2.6.24-rc2 if you think they're okay.

Thanks and regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com

