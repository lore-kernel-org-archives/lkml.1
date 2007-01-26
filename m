Return-Path: <linux-kernel-owner+w=401wt.eu-S1030769AbXAZGMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030769AbXAZGMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXAZGMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:12:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030769AbXAZGMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:12:32 -0500
Date: Thu, 25 Jan 2007 22:09:16 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 7/8] user ns: handle file sigio
Message-Id: <20070125220916.3d112f24.akpm@osdl.org>
In-Reply-To: <20070126053808.GA30017@sergelap.austin.ibm.com>
References: <20061219225902.GA25904@sergelap.austin.ibm.com>
	<20061219230127.GH25904@sergelap.austin.ibm.com>
	<m1zm881gq4.fsf@ebiederm.dsl.xmission.com>
	<20070124185845.GA597@sergelap.austin.ibm.com>
	<20070125001253.75f899d6.akpm@osdl.org>
	<20070125153239.GA17904@sergelap.austin.ibm.com>
	<20070126053808.GA30017@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 23:38:08 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

>  fs/fcntl.c            |    3 +--
>  include/linux/sched.h |    4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)

My confidence in this lot:

introduce-and-use-get_task_mnt_ns.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch
# user-ns-hook-permission.patch: Eric no like
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
# user_ns-handle-file-sigio.patch: Eric no like
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user_ns-handle-file-sigio-fix-2.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
#
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
#
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch

is very low.  If I can by some miracle get all this gunk to compile and
boot a bit, I'd ask that we all very carefully review the patches which
landed and make sure that we're all happy with it.

That's still a couple of days away, I expect.
