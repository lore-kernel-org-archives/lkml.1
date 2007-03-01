Return-Path: <linux-kernel-owner+w=401wt.eu-S1161210AbXCAXED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161210AbXCAXED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161212AbXCAXED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:04:03 -0500
Received: from mail.app.aconex.com ([203.89.192.138]:51932 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161210AbXCAXEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:04:00 -0500
X-Greylist: delayed 1607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 18:04:00 EST
Subject: Re: [RFC] Heads up on sys_fallocate()
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070301142537.b5950cd7.akpm@linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com>
	 <20070301142537.b5950cd7.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Aconex
Date: Fri, 02 Mar 2007 09:40:54 +1100
Message-Id: <1172788855.26078.294.camel@edge>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
> On Fri, 2 Mar 2007 00:04:45 +0530
> "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > This is to give a heads up on few patches that we will be soon coming up
> > with. These patches implement a new system call sys_fallocate() and a
> > new inode operation "fallocate", for persistent preallocation. The new
> > system call, as Andrew suggested, will look like:
> > 
> >   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> ...
> 
> I'd agree with Eric on the "command" flag extension.

Seems like a separate syscall would be better, "command" sounds
a bit ioctl like, especially if that command is passed into the
filesystems..

cheers.

-- 
Nathan

