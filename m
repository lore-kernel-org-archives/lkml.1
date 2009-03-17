Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZCQXOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZCQXOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZCQXOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:14:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:1028 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZCQXOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:14:19 -0400
Date: Wed, 18 Mar 2009 10:14:16 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: What's coming in the security subsystem
Message-ID: <alpine.LRH.2.00.0903181010030.6028@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what to expect in 2.6.30, currently carried in linux-next via the 
security-testing tree[1].  

Notable new features include IMA and TOMOYO, while SELinux gets some 
cleanup love.


David P. Quigley (3):
      SELinux: Condense super block security structure flags and cleanup necessary code.
      SELinux: Add new security mount option to indicate security label support.
      SELinux: Unify context mount and genfs behavior

Eric Paris (12):
      SELinux: call capabilities code directory
      SELinux: better printk when file with invalid label found
      SELinux: NULL terminate al contexts from disk
      SELinux: check seqno when updating an avc_node
      SELinux: remove the unused ae.used
      SELinux: more careful use of avd in avc_has_perm_noaudit
      SELinux: remove unused av.decided field
      SELinux: code readability with avc_cache
      SELinux: convert the avc cache hash list to an hlist
      SELinux: open perm for sock files
      SELinux: new permission between tty audit and audit socket
      SELinux: inode_doinit_with_dentry drop no dentry printk

James Morris (23):
      maintainers: add security subsystem wiki
      selinux: remove unused bprm_check_security hook
      selinux: remove secondary ops call to bprm_committing_creds
      selinux: remove secondary ops call to bprm_committed_creds
      selinux: remove secondary ops call to sb_mount
      selinux: remove secondary ops call to sb_umount
      selinux: remove secondary ops call to inode_link
      selinux: remove secondary ops call to inode_unlink
      selinux: remove secondary ops call to inode_mknod
      selinux: remove secondary ops call to inode_follow_link
      selinux: remove secondary ops call to inode_permission
      selinux: remove secondary ops call to inode_setattr
      selinux: remove secondary ops call to file_mprotect
      selinux: remove secondary ops call to task_create
      selinux: remove unused cred_commit hook
      selinux: remove secondary ops call to task_setrlimit
      selinux: remove secondary ops call to task_kill
      selinux: remove secondary ops call to unix_stream_connect
      selinux: remove secondary ops call to shm_shmat
      selinux: remove hooks which simply defer to capabilities
      IMA: fix ima_delete_rules() definition
      Merge branch 'master' into next
      security: change link order of LSMs so security=tomoyo works

Kentaro Takeda (8):
      Add in_execve flag into task_struct.
      Memory and pathname management functions.
      Common functions for TOMOYO Linux.
      File operation restriction part.
      Domain transition handler.
      LSM adapter functions.
      Kconfig and Makefile
      MAINTAINERS info

Mimi Zohar (11):
      integrity: IMA hooks
      integrity: IMA as an integrity service provider
      integrity: IMA display
      integrity: IMA policy
      integrity: IMA policy open
      Integrity: IMA file free imbalance
      Integrity: IMA update maintainers
      integrity: shmem zero fix
      integrity: audit update
      integrity: ima scatterlist bug fix
      integrity: ima iint radix_tree_lookup locking fix

Rajiv Andrade (3):
      TPM: sysfs functions consolidation
      TPM: integrity interface
      TPM: integrity fix

Randy Dunlap (2):
      ima: fix build error
      smack: fix lots of kernel-doc notation

Serge E. Hallyn (5):
      securityfs: fix long-broken securityfs_create_file comment
      keys: distinguish per-uid keys in different namespaces
      keys: consider user namespace in key_permission
      keys: skip keys from another user namespace
      keys: make procfiles per-user-namespace

Tetsuo Handa (4):
      tomoyo: fix sparse warning
      TOMOYO: Fix exception policy read failure.
      TOMOYO: Don't create securityfs entries unless registered.
      TOMOYO: Do not call tomoyo_realpath_init unless registered.

etienne (1):
      smack: fixes for unlabeled host support



[1] git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6

-- 
James Morris
<jmorris@namei.org>
