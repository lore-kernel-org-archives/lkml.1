Return-Path: <linux-kernel-owner+w=401wt.eu-S2992589AbXDDFDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589AbXDDFDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992600AbXDDFDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:03:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992589AbXDDFDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:03:50 -0400
Date: Wed, 4 Apr 2007 01:03:45 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: nfs lockdep report.
Message-ID: <20070404050345.GA22822@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Don't know if this got reported yet. It's slightly stale
(against 2.6.21-rc4-git6), but I don't recall seeing
anything in the changelogs recently that would make this
irrelevant.

	Dave

-- 
http://www.codemonkey.org.uk

--J/dobhs11T7y2rNN
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <kernel-maint-admin@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.1.8 (2007-02-13) on
	gelk.kernelslacker.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=5.0 tests=AWL,BAYES_00,NO_REAL_NAME,
	UNPARSEABLE_RELAY autolearn=no version=3.1.8
Received: from pobox.devel.redhat.com [10.11.255.8]
	by gelk.kernelslacker.org with IMAP (fetchmail-6.3.6)
	for <davej@localhost> (single-drop); Tue, 27 Mar 2007 09:45:54 -0400 (EDT)
Received: from pobox.devel.redhat.com ([unix socket])
	 by pobox.devel.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-3.RHEL4.1) with LMTPA;
	 Tue, 27 Mar 2007 09:45:05 -0400
X-Sieve: CMU Sieve 2.2
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l2RDj50L028858;
	Tue, 27 Mar 2007 09:45:05 -0400
Received: from post-office.corp.redhat.com (post-office.corp.redhat.com [172.16.52.227])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l2RDj391021813;
	Tue, 27 Mar 2007 09:45:04 -0400
Received: from post-office.corp.redhat.com (localhost.localdomain [127.0.0.1])
	by post-office.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l2RDj3ne029910;
	Tue, 27 Mar 2007 09:45:03 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by post-office.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l2RDi7gL029593
	for <kernel-maint@post-office.corp.redhat.com>; Tue, 27 Mar 2007 09:44:07 -0400
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l2RDi7Cl021287
	for <kernel-maint@redhat.com>; Tue, 27 Mar 2007 09:44:07 -0400
Received: from bugzilla.redhat.com (bugzilla.redhat.com [172.16.48.198])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l2RDi6Dd012865
	for <kernel-maint@redhat.com>; Tue, 27 Mar 2007 09:44:06 -0400
Received: from bugzilla.redhat.com (localhost.localdomain [127.0.0.1])
	by bugzilla.redhat.com (8.13.1/8.13.1) with ESMTP id l2RDi6NG013662
	for <kernel-maint@redhat.com>; Tue, 27 Mar 2007 09:44:06 -0400
Received: (from apache@localhost)
	by bugzilla.redhat.com (8.13.1/8.13.1/Submit) id l2RDi6Ti013661;
	Tue, 27 Mar 2007 09:44:06 -0400
From: bugzilla@redhat.com
To: kernel-maint@redhat.com
Subject: [Bug 234140] New: possible circular locking dependency detected
Content-type: text/plain; charset=utf-8
Message-ID: <bug-234140-176318@bugzilla.redhat.com>
X-Loop: bugzilla@redhat.com
X-BeenThere: bugzilla@redhat.com
X-Bugzilla-Product: Fedora Core
X-Bugzilla-Version: devel
X-Bugzilla-Component: kernel
X-Bugzilla-Status: NEW
X-Bugzilla-Comment: Public
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Changed-Fields: New
Sender: kernel-maint-admin@redhat.com
Errors-To: kernel-maint-admin@redhat.com
X-BeenThere: kernel-maint@redhat.com
X-Mailman-Version: 2.0.13
Precedence: bulk
List-Help: <mailto:kernel-maint-request@redhat.com?subject=help>
List-Post: <mailto:kernel-maint@redhat.com>
List-Subscribe: <http://post-office.corp.redhat.com/mailman/listinfo/kernel-maint>,
	<mailto:kernel-maint-request@redhat.com?subject=subscribe>
List-Id: <kernel-maint.redhat.com>
List-Unsubscribe: <http://post-office.corp.redhat.com/mailman/listinfo/kernel-maint>,
	<mailto:kernel-maint-request@redhat.com?subject=unsubscribe>
List-Archive: <http://post-office.corp.redhat.com/mailman/private/kernel-maint/>
Date: Tue, 27 Mar 2007 09:44:06 -0400

Please do not reply directly to this email. All additional
comments should be made in the comments box of this bug report.




https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=234140

           Summary: possible circular locking dependency detected
           Product: Fedora Core
           Version: devel
          Platform: x86_64
        OS/Version: Linux
            Status: NEW
          Severity: medium
          Priority: medium
         Component: kernel
        AssignedTo: kernel-maint@redhat.com
        ReportedBy: greenrd@greenrd.org
         QAContact: bbrock@redhat.com


Description of problem:
I got the "possible circular locking dependency detected" message in my
/var/log/messages, as shown in this excerpt:

Mar 25 21:14:57 greenrd sshd(pam_unix)[28494]: session opened for user greenrd
by (uid=0)
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel:
=======================================================
Mar 25 21:15:10 greenrd kernel: [ INFO: possible circular locking dependency
detected ]
Mar 25 21:15:10 greenrd kernel: 2.6.20-1.3017.fc7 #1
Mar 25 21:15:10 greenrd kernel:
-------------------------------------------------------
Mar 25 21:15:10 greenrd kernel: kdesktop/28739 is trying to acquire lock:
Mar 25 21:15:10 greenrd kernel:  (&inode->i_mutex){--..}, at:
[<ffffffff802622fe>] mutex_lock+0x2a/0x2e
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: but task is already holding lock:
Mar 25 21:15:10 greenrd kernel:  (&mm->mmap_sem){----}, at: [<ffffffff802243dd>]
sys_mmap+0x73/0x119
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: which lock already depends on the new lock.
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: the existing dependency chain (in reverse order) is:
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: -> #1 (&mm->mmap_sem){----}:
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a3574>]
__lock_acquire+0xa27/0xbd1
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a3b14>] lock_acquire+0x4c/0x65
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802660d8>]
do_page_fault+0x3b5/0x7ed
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8029e725>] down_read+0x3e/0x4a
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802660d8>]
do_page_fault+0x3b5/0x7ed
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802622bb>]
__mutex_lock_slowpath+0x280/0x299
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a24c7>]
mark_held_locks+0x53/0x7a
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802622bb>]
__mutex_lock_slowpath+0x280/0x299
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802642dd>] error_exit+0x0/0x96
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802e1897>] pipe_read+0x106/0x374
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802e185e>] pipe_read+0xcd/0x374
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8020d14d>] do_sync_read+0xe2/0x126
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8029c2eb>]
autoremove_wake_function+0x0/0x38
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802bafb8>]
audit_syscall_entry+0x148/0x17e
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8020b4d2>] vfs_read+0xcc/0x175
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802114bc>] sys_read+0x47/0x6f
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
Mar 25 21:15:10 greenrd kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: -> #0 (&inode->i_mutex){--..}:
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a346c>]
__lock_acquire+0x91f/0xbd1
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a3b14>] lock_acquire+0x4c/0x65
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8026213a>]
__mutex_lock_slowpath+0xff/0x299
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8020e1ca>]
do_mmap_pgoff+0x45b/0x7fa
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
Mar 25 21:15:10 greenrd kernel:        [<ffffffff88466ca0>]
nfs_revalidate_mapping+0x6d/0xac [nfs]
Mar 25 21:15:10 greenrd kernel:        [<ffffffff88464784>]
nfs_file_mmap+0x4d/0x65 [nfs]
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8020e26c>]
do_mmap_pgoff+0x4fd/0x7fa
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802a26ca>]
trace_hardirqs_on+0x136/0x15a
Mar 25 21:15:10 greenrd kernel:        [<ffffffff802243fa>] sys_mmap+0x90/0x119
Mar 25 21:15:10 greenrd kernel:        [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
Mar 25 21:15:10 greenrd kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: other info that might help us debug this:
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: 1 lock held by kdesktop/28739:
Mar 25 21:15:10 greenrd kernel:  #0:  (&mm->mmap_sem){----}, at:
[<ffffffff802243dd>] sys_mmap+0x73/0x119
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: stack backtrace:
Mar 25 21:15:10 greenrd kernel: 
Mar 25 21:15:10 greenrd kernel: Call Trace:
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802a1b0f>]
print_circular_bug_tail+0x70/0x7b
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802a346c>] __lock_acquire+0x91f/0xbd1
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802a3b14>] lock_acquire+0x4c/0x65
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
Mar 25 21:15:10 greenrd kernel:  [<ffffffff8026213a>]
__mutex_lock_slowpath+0xff/0x299
Mar 25 21:15:10 greenrd kernel:  [<ffffffff8020e1ca>] do_mmap_pgoff+0x45b/0x7fa
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
Mar 25 21:15:10 greenrd kernel:  [<ffffffff88466ca0>]
:nfs:nfs_revalidate_mapping+0x6d/0xac
Mar 25 21:15:10 greenrd kernel:  [<ffffffff88464784>] :nfs:nfs_file_mmap+0x4d/0x65
Mar 25 21:15:10 greenrd kernel:  [<ffffffff8020e26c>] do_mmap_pgoff+0x4fd/0x7fa
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802a26ca>] trace_hardirqs_on+0x136/0x15a
Mar 25 21:15:10 greenrd kernel:  [<ffffffff802243fa>] sys_mmap+0x90/0x119
Mar 25 21:15:10 greenrd kernel:  [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
Mar 25 21:15:10 greenrd kernel: 


Version-Release number of selected component (if applicable):
kernel-2.6.20-1.3017.fc7

How to reproduce:
No idea

-- 
Configure bugmail: https://bugzilla.redhat.com/bugzilla/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

--J/dobhs11T7y2rNN--
