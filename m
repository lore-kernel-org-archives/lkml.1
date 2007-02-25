Return-Path: <linux-kernel-owner+w=401wt.eu-S964805AbXBYLsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbXBYLsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXBYLsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:48:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805AbXBYLsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:48:06 -0500
Date: Sun, 25 Feb 2007 03:47:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 0/6] KVM userspace interface updates for 2.6.21
Message-Id: <20070225034737.16353a46.akpm@linux-foundation.org>
In-Reply-To: <45E15DBF.8000106@qumranet.com>
References: <45DC8B6E.5050205@qumranet.com>
	<45DC8D97.9060408@qumranet.com>
	<45E15DBF.8000106@qumranet.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 25 Feb 2007 11:58:23 +0200 Avi Kivity <avi@qumranet.com> wrote:
> Avi Kivity wrote:
> >
> > The patchset, along with the previous fixset, is available as a git 
> > tree from git://kvm.qumranet.com/home/avi/kvm/linux-2.6.  You may wish 
> > to plant it in your little git forest.
> >
> 
> This is now git://kvm.qumranet.com/home/avi/kvm.git, as a bare 'git 
> pull' will pull the current branch instead of master, giving you 
> whatever I was working on at the moment.  The kvm.git repo will always 
> have 'master' as the current branch.

OK.

 drivers/kvm/kvm.h         |   13 +
 drivers/kvm/kvm_main.c    |  774 ++++++++++++++++++++++++++++++++-------------
 drivers/kvm/kvm_svm.h     |    3 
 drivers/kvm/mmu.c         |   36 +-
 drivers/kvm/paging_tmpl.h |   18 +
 drivers/kvm/svm.c         |   42 ++
 drivers/kvm/vmx.c         |   33 ++
 include/linux/kvm.h       |   50 ++-
 include/linux/kvm_para.h  |   73 ++++

However things might get messy later on if that tree starts introducing changes
outside drivers/kvm.  There's a ton of activity in x86-world.

But if there are problems, you'll hear about it ;)
