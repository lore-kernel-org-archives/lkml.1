Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYE3PMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYE3PMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYE3PMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:12:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYE3PMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:12:15 -0400
Date: Fri, 30 May 2008 11:05:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: kernel: sysctl table check failed:
	/dev/parport/parport0/devices/ppdev0/timeslice Sysctl already exists
Message-ID: <20080530150515.GA30397@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Well, that's umm, special.
I wonder if powering off the printer isn't causing the sysctl to be removed,
causing the next power-on to look like a new device ?
Eric, you poked around the sysctl paths in parport last year, any ideas?

	Dave

-- 
http://www.codemonkey.org.uk

--XsQoSWH+UP9D9v3l
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <kernel-maint-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on
	gelk.kernelslacker.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=AWL,BAYES_00,
	UNPARSEABLE_RELAY autolearn=ham version=3.2.4
Received: from pobox.devel.redhat.com [10.11.255.8]
	by gelk.kernelslacker.org with IMAP (fetchmail-6.3.8)
	for <davej@localhost> (single-drop); Fri, 30 May 2008 10:54:21 -0400 (EDT)
Received: from pobox.devel.redhat.com ([unix socket])
	 by pobox.devel.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-8.1.RHEL4) with LMTPA;
	 Fri, 30 May 2008 10:16:25 -0400
X-Sieve: CMU Sieve 2.2
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id m4UEGOXc015858;
	Fri, 30 May 2008 10:16:24 -0400
Received: from post-office.corp.redhat.com (post-office.corp.redhat.com [10.11.254.111])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4UEGJav001061;
	Fri, 30 May 2008 10:16:19 -0400
Received: from post-office.corp.redhat.com (localhost.localdomain [127.0.0.1])
	by post-office.corp.redhat.com (8.13.8/8.13.8) with ESMTP id m4UEGJ4I026115;
	Fri, 30 May 2008 10:16:19 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com
	[172.16.52.254])
	by post-office.corp.redhat.com (8.13.8/8.13.8) with ESMTP id
	m4UEGHrf026102 for <kernel-maint@post-office.corp.redhat.com>;
	Fri, 30 May 2008 10:16:17 -0400
Received: from mx1.util.phx.redhat.com (mx1.util.phx.redhat.com [10.8.4.92])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4UEGGY3000925
	for <kernel-maint@int-mx1.corp.redhat.com>;
	Fri, 30 May 2008 10:16:17 -0400
Received: from bz-web2.app.phx.redhat.com (nat-pool.util.phx.redhat.com
	[10.8.5.200])
	by mx1.util.phx.redhat.com (8.13.1/8.13.1) with ESMTP id m4UEGBv4006955
	for <kernel-maint@redhat.com>; Fri, 30 May 2008 10:16:11 -0400
Received: from bz-web2.app.phx.redhat.com (localhost.localdomain [127.0.0.1])
	by bz-web2.app.phx.redhat.com (8.13.1/8.13.1) with ESMTP id
	m4UEG8LQ025346
	for <kernel-maint@redhat.com>; Fri, 30 May 2008 10:16:11 -0400
Received: (from apache@localhost)
	by bz-web2.app.phx.redhat.com (8.13.1/8.13.1/Submit) id m4UEFp0B025119; 
	Fri, 30 May 2008 10:15:51 -0400
Date: Fri, 30 May 2008 10:15:51 -0400
From: bugzilla@redhat.com
To: kernel-maint@redhat.com
Subject: [Bug 449112] New: kernel:<3>sysctl table check failed:
	/dev/parport/parport0/devices/ppdev0/timeslice Sysctl already exists
Content-type: text/plain; charset=utf-8
Message-ID: <bug-449112-176318@bugzilla.redhat.com>
X-Loop: bugzilla@redhat.com
X-BeenThere: bugzilla@redhat.com
X-Bugzilla-Product: Fedora
X-Bugzilla-Version: rawhide
X-Bugzilla-Component: kernel
X-Bugzilla-Status: NEW
X-Bugzilla-Comment: Public
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Changed-Fields: New
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-BeenThere: kernel-maint@redhat.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <kernel-maint.redhat.com>
List-Unsubscribe: <http://post-office.corp.redhat.com/mailman/listinfo/kernel-maint>,
	<mailto:kernel-maint-request@redhat.com?subject=unsubscribe>
List-Archive: <http://post-office.corp.redhat.com/mailman/private/kernel-maint>
List-Post: <mailto:kernel-maint@redhat.com>
List-Help: <mailto:kernel-maint-request@redhat.com?subject=help>
List-Subscribe: <http://post-office.corp.redhat.com/mailman/listinfo/kernel-maint>,
	<mailto:kernel-maint-request@redhat.com?subject=subscribe>
Sender: kernel-maint-bounces@redhat.com
Errors-To: kernel-maint-bounces@redhat.com

Please do not reply directly to this email. All additional
comments should be made in the comments box of this bug report.




https://bugzilla.redhat.com/show_bug.cgi?id=449112

           Summary: kernel:<3>sysctl table check failed:
                    /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl
                    already exists
           Product: Fedora
           Version: rawhide
          Platform: All
        OS/Version: Linux
            Status: NEW
          Severity: low
          Priority: low
         Component: kernel
        AssignedTo: kernel-maint@redhat.com
        ReportedBy: selinux@gmail.com
         QAContact: extras-qa@fedoraproject.org


Description of problem:
Get the following in dmesg. I had "printed" to an HP5MP printer from firefox,
but the printer was powered off.  I turned on the printer, and I believe got these.

ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice 
Sysctl already exists
Pid: 3921, comm: hp Not tainted 2.6.26-0.44.rc4.git2.fc10.i686 #1
 [<c04407ae>] set_fail+0x33/0x40
 [<c0440bc4>] sysctl_check_table+0x409/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c043148c>] __register_sysctl_paths+0xa7/0xf9
 [<c04314fc>] register_sysctl_paths+0x1e/0x20
 [<c043150d>] register_sysctl_table+0xf/0x11
 [<f8db831f>] parport_device_proc_register+0xa9/0xc7 [parport]
 [<f8db6b2c>] parport_register_device+0x1c1/0x1eb [parport]
 [<f8dfe328>] pp_ioctl+0x12e/0x6b2 [ppdev]
 [<f8dfe8ac>] ? pp_irq+0x0/0x43 [ppdev]
 [<c04982ac>] vfs_ioctl+0x50/0x69
 [<c04984fe>] do_vfs_ioctl+0x239/0x24c
 [<c04df7dc>] ? selinux_file_ioctl+0x35/0x38
 [<c0498551>] sys_ioctl+0x40/0x5b
 [<c0404c3a>] syscall_call+0x7/0xb
 =======================
ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice 
Sysctl already exists
Pid: 3921, comm: hp Not tainted 2.6.26-0.44.rc4.git2.fc10.i686 #1
 [<c04407ae>] set_fail+0x33/0x40
 [<c0440bc4>] sysctl_check_table+0x409/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c0440bda>] sysctl_check_table+0x41f/0x445
 [<c043148c>] __register_sysctl_paths+0xa7/0xf9
 [<c04314fc>] register_sysctl_paths+0x1e/0x20
 [<c043150d>] register_sysctl_table+0xf/0x11
 [<f8db831f>] parport_device_proc_register+0xa9/0xc7 [parport]
 [<f8db6b2c>] parport_register_device+0x1c1/0x1eb [parport]
 [<f8dfe328>] pp_ioctl+0x12e/0x6b2 [ppdev]
 [<f8dfe8ac>] ? pp_irq+0x0/0x43 [ppdev]
 [<c04982ac>] vfs_ioctl+0x50/0x69
 [<c04984fe>] do_vfs_ioctl+0x239/0x24c
 [<c04df7dc>] ? selinux_file_ioctl+0x35/0x38
 [<c0498551>] sys_ioctl+0x40/0x5b
 [<c0404c3a>] syscall_call+0x7/0xb
 =======================
ppdev0: registered pardevice
ppdev0: unregistered pardevice
ppdev0: unregistered pardevice
ppdev0: unregistered pardevice


Version-Release number of selected component (if applicable):
kernel-2.6.26-0.44.rc4.git2.fc10.i686

How reproducible:
Don't know....

Steps to Reproduce:
1.
2.
3.
  
Actual results:


Expected results:


Additional info:

-- 
Configure bugmail: https://bugzilla.redhat.com/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

--XsQoSWH+UP9D9v3l--
