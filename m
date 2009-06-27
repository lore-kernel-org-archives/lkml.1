Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZF0Q06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZF0Q06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZF0Q0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:26:49 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46315 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbZF0Q0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=De0MK7xKLKuHBG2IQC3Sr0AF5pOPCgoXrSDM8mZCfYG7HVlK8gsgaASeAvHiLo6JIN
         g8YgpZ+AwjwBkIbbO6PHt06C89qxKjLc2ZKYNnuWqdqLembvpbQyhqZLvyUe8ACymPUx
         V0MGIpxqvKQ9RMmAt+4WV34e9g2Rc2gjSlkEo=
MIME-Version: 1.0
Date: Sat, 27 Jun 2009 09:26:50 -0700
Message-ID: <1faf47660906270926s38ee652dtf9150febb60b358e@mail.gmail.com>
Subject: BUG: mmotm-2009-0625-1549 quilt fails at procfs-provide-stack-information-for-threads-v08.patch
From: "Charles 'Mack' Rhinelander" <mrhinelander@gmail.com>
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting quilt push -a with mmotm-2009-0625-1549, failure at
procfs-provide-stack-information-for-threads-v08.patch as below. quilt
enters infinite loop:  "No file to patch.  Skipping patch. \can't find
file to patch at input line 20" See below.

---CUT HERE---
Applying patch proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
patching file drivers/connector/cn_proc.c

Applying patch procfs-provide-stack-information-for-threads-v08.patch
can't find file to patch at input line 20
The text leading up to this was:
--------------------------
|From: Stefani Seibold <stefani@seibold.net>
|
|A patch to give a better overview of the userland application stack usage,
|especially for embedded linux.
|
|Currently you are only able to dump the main process/thread stack usage
|which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
|information about the consumed stack memory of the the threads.
|
|There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
|the vm mapping where the thread stack pointer reside with "[thread stack
|xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
|information, because libpthread doesn't set the start of the stack to the
|top of the mapped area, depending of the pthread usage.
|
|A sample output of /proc/<pid>/task/<tid>/maps looks like:
|
|08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
|08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
--------------------------
No file to patch.  Skipping patch.
can't find file to patch at input line 20
No file to patch.  Skipping patch.
can't find file to patch at input line 20
<etc.>
