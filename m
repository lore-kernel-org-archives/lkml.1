Return-Path: <linux-kernel-owner+w=401wt.eu-S941523AbXGTQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941523AbXGTQg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939521AbXGTQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:36:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S941194AbXGTQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:36:21 -0400
Date: Fri, 20 Jul 2007 09:35:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "David Chinner" <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] XFS build error
Message-Id: <20070720093525.3c709be3.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0707200802h262af4f7q48e35e3a7f732a4a@mail.gmail.com>
References: <6bffcb0e0707200802h262af4f7q48e35e3a7f732a4a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 17:02:13 +0200 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> Hi David,
> 
> I get this build error on the latest -mm snapshot
> 
> fs/xfs/linux-2.6/xfs_file.c:483: error: unknown field 'populate'
> specified in initializer
> fs/xfs/linux-2.6/xfs_file.c:483: error: 'filemap_populate' undeclared
> here (not in a function)
> fs/xfs/linux-2.6/xfs_file.c:483: warning: excess elements in struct initializer
> fs/xfs/linux-2.6/xfs_file.c:483: warning: (near initialization for
> 'xfs_file_vm_ops')
> make[2]: *** [fs/xfs/linux-2.6/xfs_file.o] Error 1
> make[1]: *** [fs/xfs] Error 2
> make: *** [fs] Error 2
> 
> quilt patches fs/xfs/linux-2.6/xfs_file.c
> patches/git-xfs.patch
> patches/git-xfs-fixup.patch

That was my lame, untested attempt to fix git conflicts in the xfs tree.

That -mm snapshot was a secret upload for Nick - you weren't supposed to
notice it ;)

I'd be stunned if it booted.
