Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbZJFSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbZJFSD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbZJFSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:03:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:44594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbZJFSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:03:25 -0400
Subject: Re: [patch] perf build questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091006102626.8b4f7810.randy.dunlap@oracle.com>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
	 <1254818939.21044.120.camel@laptop>
	 <20091006102626.8b4f7810.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 20:02:48 +0200
Message-Id: <1254852168.17055.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 10:26 -0700, Randy Dunlap wrote:
> On Tue, 06 Oct 2009 10:48:59 +0200 Peter Zijlstra wrote:
> 
> > On Mon, 2009-10-05 at 13:17 -0700, Randy Dunlap wrote:
> > > Hi,
> > > 
> > > How do I build 'perf' for an i386 target when running on x86_64?
> > 
> > make NO_64BIT=1
> 
> $ make NO_64BIT=1 all
> $ file perf
> perf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped
> 
> 
> Shouldn't that be a 32-bit executable for i386?
> Am I confused?  (you don't have to answer that)

# uname -a
Linux twins 2.6.31-tip #212 SMP PREEMPT Tue Sep 22 12:02:22 CEST 2009
x86_64 GNU/Linux
# rm perf
# make NO_64BIT=1 perf
# file perf
perf: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),
dynamically linked (uses shared libs), for GNU/Linux 2.6.15, not
stripped


seems to work for me...



