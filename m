Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYKKOPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYKKOPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYKKOPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:15:08 -0500
Received: from main.gmane.org ([80.91.229.2]:54937 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbYKKOPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:15:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: NFS root hangs
Date: Tue, 11 Nov 2008 14:10:25 +0000
Message-ID: <gfc3oh$85h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: xpc17.ast.cam.ac.uk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi - We're running several diskless x86-64 systems with a MS-6702
motherboard with an Athlon 64 3400+ CPU. The network driver is an onboard
R8169 (rev 10) using gigabit ethernet. The kernel is 2.6.26.6-49.fc8 (i.e.
the latest Fedora 8 kernel). The root partition is mounted over NFS (v3) in
an initrd init script.

This setup works fine for some dual core Athlon 64s and single core x86
Pentium 4s. However the diskless single core Athlon 64 systems lock up
randomly after minutes or tens of minutes of idleness.

The do not print any oops debugging information. They are not pingable. They
do not respond to alt+sysctl commands. They also lock up with an active CPU
as they generate a lot of heat while crashed. We've also tried noapic,
noacpi boot options. We've also tried to enable nmi_watchdog=2, which
doesn't give any debugging information either. We've also tried adjusting
the various NFS mount options with no effect (rsize/wsize/nfsvers/udp/tcp).
In x86 mode the systems also hang, but take a lot longer to do it.

We suspect the R8169 is at fault as our other systems work. The systems used
to work, but something has started this problem. Old kernels do not fix the
problem.

Does anyone have any ideas or tips on how to debug this problem?

Thanks

Jeremy


