Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbXF1SeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbXF1SeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXF1SeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:34:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757585AbXF1Sd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:33:59 -0400
Date: Thu, 28 Jun 2007 11:33:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
       cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-Id: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
In-Reply-To: <20070628175757.GA1674@amitarora.in.ibm.com>
References: <20070510223950.GD86004887@sgi.com>
	<20070511110301.GB28425@in.ibm.com>
	<20070512080157.GF85884050@sgi.com>
	<20070612061652.GA6320@amitarora.in.ibm.com>
	<20070613235217.GS86004887@sgi.com>
	<20070614091458.GH5181@schatzie.adilger.int>
	<20070614120413.GD86004887@sgi.com>
	<20070614193347.GN5181@schatzie.adilger.int>
	<20070625132810.GA1951@amitarora.in.ibm.com>
	<20070628025543.9467216f.akpm@linux-foundation.org>
	<20070628175757.GA1674@amitarora.in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 23:27:57 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> > Please drop the non-ext4 patches from the ext4 tree and send incremental
> > patches against the (non-ext4) fallocate patches in -mm.
> 
> Please let us know what you think of Mingming's suggestion of posting
> all the fallocate patches including the ext4 ones as incremental ones
> against the -mm.

I think Mingming was asking that Ted move the current quilt tree into git,
presumably because she's working off git.

I'm not sure what to do, really.  The core kernel patches need to be in
Ted's tree for testing but that'll create a mess for me.

ug.

Options might be

a) I drop the fallocate patches from -mm and from the ext4 tree, hack up
   any needed build fixes, then just wait for it all to mature and then
   think about it again

b) We do what we normally don't do and reserve the syscall slots in mainline.

