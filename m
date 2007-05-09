Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXEIMrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXEIMrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXEIMq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:46:57 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:22704 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXEIMq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:46:56 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 0/6] IB/ehca: Assorted patches
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 14:46:23 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200705091446.23783.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a set of patches containing various improvements and bugfixes for the
IBM eHCA InfiniBand driver, bumping the version number to SVNEHCA_0023. The
patches are, in detail:

#1 - Serialize hypervisor calls in ehca_register_mr()
#2 - correctly set GRH mask bit in ehca_modify_qp()
#3 - Fix AQP0/1 QP number
#4 - remove _irqsave where it's not needed;
     move an #ifdef to where it makes even better sense
#5 - beautify sysfs attribute code and fix compiler warnings
#6 - disable scaling code by default and bump version number

The patches are ready for inclusion into 2.6.22 and apply on top of Roland's
git tree (which has been pulled by Linus recently, so they should apply there,
too).

Cheers,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239

