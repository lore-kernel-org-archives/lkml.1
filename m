Return-Path: <linux-kernel-owner+w=401wt.eu-S1767663AbXEDFQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767663AbXEDFQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767672AbXEDFQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:16:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43077 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767663AbXEDFQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:16:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17978.47502.786970.196554@cargo.ozlabs.ibm.com>
Date: Fri, 4 May 2007 14:41:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and
 powerpc
In-Reply-To: <20070503212955.b1b6443c.akpm@linux-foundation.org>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426180332.GA7209@amitarora.in.ibm.com>
	<20070503212955.b1b6443c.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > This patch implements the fallocate() system call and adds support for
> > i386, x86_64 and powerpc.
> > 
> > ...
> >
> > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> Please add a comment over this function which specifies its behaviour. 
> Really it should be enough material from which a full manpage can be
> written.

This looks like it will have the same problem on s390 as
sys_sync_file_range.  Maybe the prototype should be:

asmlinkage long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)

Paul.
