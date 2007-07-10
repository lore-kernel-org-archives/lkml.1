Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXGJM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXGJM7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXGJM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:59:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbXGJM7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:59:08 -0400
Date: Tue, 10 Jul 2007 14:59:05 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710125904.GC22862@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070710063624.GB5471@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710063624.GB5471@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-10 08:36]:
> > does anybody know a _reliable_ way to determine the version the kernel
> > that produced a vmcore file? This means not scanning for a specific
> > string or something like that which can fail on random memory.
> > 
> > Would it make sense to add a ELF PT_NOTE section in the vmcore?
> 
> To me it makes sense to append an ELF NOTE to vmcore which can uniquely
> associate that vmcore with a particular vmlinux file (Some string
> equivalent to the output of uname -a).

Well, if we embed the CONFIGFILE from makedumpfile in some magic way
we don't need it ... we'll see.

> Interesting thing is that to find version of vmlinux, you will still be
> doing <string | grep "some pattern">. Probably then we should append an
> ELF note to vmlinux file also?

Yes, that was my proposal some time ago, see
http://article.gmane.org/gmane.comp.boot-loaders.fastboot.general/3996
Any comments on that patch are appreciated. :)


Thanks,
   Bernhard
