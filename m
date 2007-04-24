Return-Path: <linux-kernel-owner+w=401wt.eu-S1161718AbXDXMQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161718AbXDXMQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161729AbXDXMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:16:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38964 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161718AbXDXMQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:16:35 -0400
Date: Tue, 24 Apr 2007 17:46:33 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com, suparna@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070424121632.GA10136@amitarora.in.ibm.com>
References: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420145918.GY355@devserv.devel.redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:59:18AM -0400, Jakub Jelinek wrote:
> On Fri, Apr 20, 2007 at 07:21:46PM +0530, Amit K. Arora wrote:
> > Ok.
> > In this case we may have to consider following things:
> > 
> > 1) Obviously, for this glibc will have to call fallocate() syscall with
> > different arguments on s390, than other archs. I think this should be
> > doable and should not be an issue with glibc folks (right?).
> 
> glibc can cope with this easily, will just add
> sysdeps/unix/sysv/linux/s390/fallocate.c or something similar to override
> the generic Linux implementation.
> 
> > 2) we also need to see how strace behaves in this case. With little
> > knowledge that I have of strace, I don't think it should depend on
> > argument ordering of a system call on different archs (since it uses
> > ptrace internally and that should take care of it). But, it will be
> > nice if someone can confirm this.
> 
> strace would solve this with #ifdef mess, it already does that in many
> places so guess another few lines don't make it significantly worse.

I will work on the revised fallocate patchset and will post it soon.

Thanks!
--
Regards,
Amit Arora
