Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXEILJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXEILJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXEILI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:08:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40144 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXEILIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:08:55 -0400
Date: Wed, 9 May 2007 16:40:11 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509111011.GA21619@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <17978.47502.786970.196554@cargo.ozlabs.ibm.com> <20070509101507.GA26056@in.ibm.com> <17985.42884.971318.859402@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17985.42884.971318.859402@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 08:50:44PM +1000, Paul Mackerras wrote:
> Suparna Bhattacharya writes:
> 
> > > This looks like it will have the same problem on s390 as
> > > sys_sync_file_range.  Maybe the prototype should be:
> > > 
> > > asmlinkage long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)
> > 
> > Yes, but the trouble is that there was a contrary viewpoint preferring that fd
> > first be maintained as a convention like other syscalls (see the following
> > posts)
> 
> Of course the interface used by an application program would have the
> fd first.  Glibc can do the translation.

I think that was understood.

Regards
Suparna

> 
> Paul.

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

