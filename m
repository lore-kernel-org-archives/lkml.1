Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbZJFSSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbZJFSSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZJFSSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:18:49 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:62099 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbZJFSSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:18:48 -0400
Date: Tue, 6 Oct 2009 11:09:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf build questions
Message-Id: <20091006110941.eebe58af.randy.dunlap@oracle.com>
In-Reply-To: <20091006180551.GB11702@bombadil.infradead.org>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
	<1254818939.21044.120.camel@laptop>
	<20091006102626.8b4f7810.randy.dunlap@oracle.com>
	<20091006180551.GB11702@bombadil.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4ACB89C9.0081:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 14:05:51 -0400 Kyle McMartin wrote:

> On Tue, Oct 06, 2009 at 10:26:26AM -0700, Randy Dunlap wrote:
> > $ make NO_64BIT=1 all
> > $ file perf
> > perf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped
> > 
> > 
> > Shouldn't that be a 32-bit executable for i386?
> > Am I confused?  (you don't have to answer that)
> > 
> 
> Are you running a 32-bit userspace, with x86_64 kernel? Or running
> x86_64 userspace as well and trying to crossbuild for i386? In the
> latter case NO_64BIT won't do what you hope, it's to avoid trying to
> build a 64-bit binary in the former case.

All 64-bit userspace & kernel.  so that fails.  Thanks.

> You could force -m32 into CFLAGS in the second case, but unless you have
> the proper i386 bi-arch toolchain installed (glibc, etc.) it likely
> won't build...

I'll test/check etc.

---
~Randy
