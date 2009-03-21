Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZCUQhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZCUQhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZCUQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:37:05 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:38786 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbZCUQhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:37:04 -0400
Date: Sat, 21 Mar 2009 17:37:00 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
Message-ID: <20090321163700.GA22292@cs.unibo.it>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014140.AA4F5FC3AB@magilla.sf.frob.com> <20090321014909.6b654f55.akpm@linux-foundation.org> <20090321140822.GE18690@cs.unibo.it> <20090321143457.GA24254@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321143457.GA24254@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 03:34:57PM +0100, Ingo Molnar wrote:
> 
> * Renzo Davoli <renzo@cs.unibo.it> wrote:
> 
> > Tracing does not mean only debug. Some tracing facilities can be 
> > used for virtualization. For example User-Mode Linux is based on 
> > ptrace.
> > 
> > I have a prototype of kernel module for virtualization (kmview) 
> > based on utrace. [...]
> 
> Hm, i cannot find the source code. Can it be downloaded from 
> somewhere?
Sure! kmview is not included in our Debian packages yet as it relies on 
(still) non mainstream features (utrace), but the code is available on 
our view-os svn repository.

Check out:
svn co https://view-os.svn.sourceforge.net/svnroot/view-os view-os 

More specifically to browse the code/specifications:
The kmview device protocol is here:
http://wiki.virtualsquare.org/index.php/KMview_module_interface_specifications
The kernel module itself is here:
http://view-os.svn.sourceforge.net/viewvc/view-os/trunk/kmview-kernel-module/
The VMM userland application share most of the code with
umview, the source code for both is here:
http://view-os.svn.sourceforge.net/viewvc/view-os/trunk/xmview-os/xmview/

kmview kernel module (current version) needs the following patches:
utrace
http://www.mail-archive.com/utrace-devel@redhat.com/msg00654.html
http://www.mail-archive.com/utrace-devel@redhat.com/msg00655.html
I am trying to keep everything up to date, but the whole stuff is
evolving in a quite fast way.

Everything has been released under GPLv2.

	renzo
