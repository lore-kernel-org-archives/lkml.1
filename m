Return-Path: <linux-kernel-owner+w=401wt.eu-S1762510AbXFEEbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762510AbXFEEbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 00:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXFEEba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 00:31:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:5490 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXFEEb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 00:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=LNHQsW7hf5hNz4vxuA5qc2apS1F3fY8louIENkSZjUE+scK53/FUp/jctjNCQQtNROH8Fm3axB5l26x02v3s+irSCEnZdExj18Gj/qmci83NxHAGH/cslPJ48on/JimWfBj3192iLBJ47ss2OOSHGp8Z+4VI+swnwT2SvkeZnSw=
Message-ID: <4664E724.7060507@gmail.com>
Date: Tue, 05 Jun 2007 00:31:32 -0400
From: Marc Chiarini <mchiarini@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with /proc/diskstats on RHEL4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Wondering if folks can help me out.  I have been doing some collection
of statistics on my Redhat boxes and have noted that the read values
in /proc/diskstats *very* rarely change.  Things like # of read
requests, reads merged, #bytes read, total time spent reading, are
just basically frozen for long periods of time.  On 2 different
physical machines running RHEL4 I have taken deltas directly from this
file while performing large numbers of reads on local hard disks (such
as zcat-ing every man page in /usr/share/man right after login).  The
write statistics show plenty of change over time, but not so for the
read statistics.  One machine has a 2.6.9-5 kernel running on a Dell
P4 and is configured with software RAID across two IDE disks.  Another
machine (actually there are several virtually identical ones) has a
2.6.9-42 kernel running on x86_64 SMP, and is configured with several
local SCSI disks (no LVM or RAID) and mounts several filesystems over
NFS.

I know that /proc/diskstats works correctly on many machines, such as
the Suse EL, FC6, and even RHEL 4AS (2.6.9-34) virtual machines I have
running on VMWare Server.  I have also witnessed it working in Xubuntu
Feisty Fawn on several similarly configured physical boxes with P3s
and SCSI disks.

If anyone knows of any bugs in diskstats (coming from the kernel side?), 
any conflicts with the hardware mentioned above, or can suggest any 
reason why this is occuring on a small subset of machines, please 
contact me.  Also, if you are using RHEL4, perhaps you might take a 
moment to see if your own /proc/diskstats is progressing on reads, and 
drop me a line about your hardware/kernel configs?

Many thanks in advance for your much appreciated help!

Regards,
Marc Chiarini


