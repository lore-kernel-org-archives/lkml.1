Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXB0QiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXB0QiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXB0QiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:38:23 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:8580 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbXB0QiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:38:22 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 0/2] ehea: dynamic port & SMP support
Date: Tue, 27 Feb 2007 17:32:02 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702271732.02531.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set includes two patches against linux-2.6.21-rc1:

- dynamic add / remove port:
  Interface has been discussed and approved by John Rose
  (see: http://www.spinics.net/lists/netdev/msg25327.html)

- NAPI multi queue TX/RX path for SMP:
  Integrated comments from mailing list (R. Dreier)
  
  As soon as discussions about "splitting NAPI from netdevice"
  have settled and this functionality is in kernel, we'll provide
  a patch for the new interface.
  (see: http://www.spinics.net/lists/netdev/msg25647.html)

please apply.

Jan-Bernd


Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
