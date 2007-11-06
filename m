Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbXKFIE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbXKFIE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbXKFIEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:04:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbXKFIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:04:48 -0500
Date: Tue, 6 Nov 2007 00:04:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [RFC] kobject and kset core changes and cleanups
Message-Id: <20071106000443.b8285085.akpm@linux-foundation.org>
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 16:57:58 -0700 Greg KH <gregkh@suse.de> wrote:

> So, I go on vacation for a week or so and come back to an overflowing
> inbox.  Instead of trying to wade through all of that, I decide to
> finish up the work Kay and I had started on cleaning up the kset core
> code.

fs/ocfs2/stackglue.c:940: error: expected ')' before '(' token
fs/ocfs2/stackglue.c: In function 'ocfs2_show':
fs/ocfs2/stackglue.c:948: error: 'ocfs2_subsys' undeclared (first use in this function)
fs/ocfs2/stackglue.c:948: error: (Each undeclared identifier is reported only once
fs/ocfs2/stackglue.c:948: error: for each function it appears in.)
fs/ocfs2/stackglue.c: In function 'ocfs2_store':
fs/ocfs2/stackglue.c:962: error: 'ocfs2_subsys' undeclared (first use in this function)
fs/ocfs2/stackglue.c: In function 'ocfs2_sys_shutdown':
fs/ocfs2/stackglue.c:972: error: 'ocfs2_subsys' undeclared (first use in this function)
fs/ocfs2/stackglue.c: In function 'ocfs2_sys_init':
fs/ocfs2/stackglue.c:979: error: 'ocfs2_subsys' undeclared (first use in this function)
fs/ocfs2/stackglue.c:980: error: implicit declaration of function 'kobj_set_kset_s'
fs/ocfs2/stackglue.c:980: error: 'fs_subsys' undeclared (first use in this function)

wrecks the ocfs2 devel tree.  I'll drop that too.

I wonder how much other out-of-tree code will be broken.
