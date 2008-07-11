Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYGKTSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYGKTSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYGKTSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435AbYGKTSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:21 -0400
Date: Fri, 11 Jul 2008 12:17:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eCryptfs: Do not try to open device files on mknod
Message-Id: <20080711121729.af5750de.akpm@linux-foundation.org>
In-Reply-To: <20080709222148.GB6773@halcrowt61p.austin.ibm.com>
References: <20080709222148.GB6773@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 17:21:48 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> When creating device nodes, eCryptfs needs to delay actually opening
> the lower persistent file until an application tries to open. Device
> handles may not be backed by anything when they first come into
> existence.

Generates a reject against your eariler
ecryptfs-privileged-kthread-for-lower-file-opens.patch.

It was easy enough to fix, but I'd sugest that you raise and test new
patches against at least the other pending ones, rather than against virgin
mainline.  Because stuff happens...
