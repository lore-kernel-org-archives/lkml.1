Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZJCFRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZJCFRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 01:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZJCFRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 01:17:22 -0400
Received: from trinity.develer.com ([83.149.158.210]:59002 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZJCFRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 01:17:22 -0400
Subject: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: linux-ide@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Sat, 03 Oct 2009 01:10:42 -0400
Message-Id: <1254546642.1438.135.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error in the subject appears in the console immediately followed bv
a hard freeze of the machine.  The error occurs reproducibly on two
identical Opteron servers, each one equipped with two identical
controller cards:

03:04.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
03:06.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)

We can trigger the problem within a few seconds by starting a
reconstruction on a drive hooked to port 4 (counting from 0) of the
second controller.  Oddly, every other drive works reliably and the
faulty drive works if we connect it to, for example, port 4 of the first
controller.

I'd like to stress that the problem occurs systematically, on two
completely distinct machines.  We swapped drives, cables and controllers
to exclude other possibilities.

Tested with Debian kernels 2.6.26-19 and 2.6.30-8.  Let me know if
further details are needed.

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

