Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXIXWpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXIXWpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbXIXWpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:45:20 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:48037 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759335AbXIXWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:45:18 -0400
Date: Mon, 24 Sep 2007 18:45:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hch@infradead.org,
       akpm <akpm@linux-foundation.org>, sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH/RFC] samples/: move kprobes sources to samples
Message-ID: <20070924224516.GA13993@Krystal>
References: <20070924145828.d279abac.randy.dunlap@oracle.com> <20070924222144.GA12041@Krystal> <46F83A5F.1070606@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F83A5F.1070606@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:44:33 up 56 days, 23:03,  4 users,  load average: 0.74, 1.31, 1.04
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> Mathieu Desnoyers wrote:
> >* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >>This is RFC patch 2/2.
> >>Patch 1/2 introduces the samples/ infrastructure:
> >>  http://lkml.org/lkml/2007/9/24/397
> >>
> >
> >Hi Randy,
> >
> >I got this when building my markers (which looks alike your kprobes):
> >
> >ld: samples/built-in.o: No such file: No such file or directory
> >make: *** [.tmp_vmlinux1] Error 1
> >
> >And the Makefile from samples does not seem to be executed. And why is
> >there a Kbuild file in your first patch ?
> 
> samples/Kbuild should be renamed to samples/Makefile.
> Sorry about that.
> 
> I made the kprobes files build only as modules.
> You are probably attempting to build markers built-in, not as
> modules?  That needs some makefile foo, I think.  Sam??
> 
> 

Ok, fixed.. Was due either to Kbuild being there (?!?) and/or the fact
that I used += markers instead of += markers/.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
