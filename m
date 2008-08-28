Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYH1LCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYH1LCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYH1LCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:02:05 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:16566 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYH1LCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:02:04 -0400
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 07:02:04 EDT
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2008 12:41:14 +0200
MIME-Version: 1.0
Subject: SLES10 SP1 (x86_64): Hard-hang when using NFSv4 from HP-UX
CC: Ulrich.windl@rz.uni-regensburg.de
Message-ID: <48B69CE9.12245.108123EC@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.27/Sophos-P=4.29.0+V=4.29+U=2.07.201+R=05 May 2008+T=405471@20080828.102727Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm fighting for a while with using NFSv4 provided by HP-UX 11.31 (ONCplus 
B.11.31.04 (ONC+ 2.3)) on a SLES10 SP1 (x86_64) client. HP's NFS is basically that 
from Sun. The problems are:

Mounting the filesystems as NFSv3 causes no problems at all, using NFSv4 makes 
every file open() attempt to hang hard. I must "kill -9" the processes. Even 
"umount -vat nfs4" hangs on umount().

The only messages I get when trying an open is
kernel: Error: state recovery failed on NFSv4 server 192.168.0.20 with error 5

For umount the error message seems to be
rksapas08 kernel: Error: state recovery failed on NFSv4 server 192.168.0.20 with 
error 2

On the HP-UX server I see messages like these, but I'm unsure whether they are 
related to Linux:
vmunix: NOTICE: sec_clnt_geth: unknown authflavor 2037596260, trying AUTH_NONE
vmunix: NOTICE: sec_clnt_geth: unknown authflavor 10, trying AUTH_NONE

When HP-UX uses NFSv4 (same software as quoted above), no such problems appear. 
The server is a four-core Itanium2 (IA64) machine.

I'd appreciate any help towards understanding the error messages and debugging the 
problem.

Regards,
Ulrich
P.S. Not subscribed, so please CC:

