Return-Path: <linux-kernel-owner+w=401wt.eu-S965954AbXIBLyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965954AbXIBLyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXIBLyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:54:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964926AbXIBLyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:54:12 -0400
Date: Sun, 2 Sep 2007 04:54:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabor Kovacs <kgabor@bolyai.elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: User process freezes on NFSv4 client
Message-Id: <20070902045401.1b8a347c.akpm@linux-foundation.org>
In-Reply-To: <200708161819.14437.kgabor@bolyai.elte.hu>
References: <200708161819.14437.kgabor@bolyai.elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 16 Aug 2007 18:19:14 -0400 Gabor Kovacs <kgabor@bolyai.elte.hu> wrote:
> Hello All,
> 
> I've got NFSv4 problems on a big partition. Both NFS server and client run 
> kernel version 2.6.21.6. Exported file system is on an AoE etherdrive 
> (/dev/etherd/e1.1) device, having no partition table, XFS file system. The 
> file system is pretty large,  8.9T. Typical file size 1-10M. 
> 
> On the client side, after much time (3-7 days) of file intensive task, the 
> user process freezes. Top command shows a "D" state for it, but many other 
> command trying to "touch" it, freezes, too. (ps, fuser /nfs_dir, w) None of 
> the frozen processes can be killed. New processes, however, can access the 
> nfs4 mounted file system. Any idea?
> 

Next time it happens, please run

	echo t > /proc/sysrq-trigger

then send the output of `dmesg -s 1000000'.  Thanks.
