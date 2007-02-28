Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXB1RkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXB1RkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbXB1RkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:40:04 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:38479 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbXB1RkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:40:00 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 0/2] ehea: dynamic port & SMP support
Date: Wed, 28 Feb 2007 18:33:45 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702281833.45603.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

this version has the issues fixed which were mentioned by
Patrick McHardy.

The patch set includes two patches against linux-2.6.21-rc1:

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
	
