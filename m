Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbXKMHmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbXKMHmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXKMHmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:42:00 -0500
Received: from [212.12.190.99] ([212.12.190.99]:41201 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbXKMHmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:42:00 -0500
From: Al Boldi <a1426z@gawab.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: top lies ?
Date: Tue, 13 Nov 2007 10:38:26 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200711131008.56627.a1426z@gawab.com> <661de9470711122319m1b8704d1y2f06b1199a21dd52@mail.gmail.com>
In-Reply-To: <661de9470711122319m1b8704d1y2f06b1199a21dd52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131038.26436.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> On Nov 13, 2007 12:38 PM, Al Boldi <a1426z@gawab.com> wrote:
> > kloczek wrote:
> > > Some data showed by top command looks like completly trashed.
> > > Fragment from top output:
> > >
> > > Mem:   2075784k total,  2053352k used,    22432k free,    19260k
> > > buffers Swap:  2096472k total,      136k used,  2096336k free, 
> > > 1335080k cached
> > >
> > >    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT WCHAN     COMMAND
> > >  14515 mysql     20   0 1837m 563m 4132 S   39  27.8 27:14.20 1.2g   18 -         mysqld
> > >
> > > How it is possible that swap ussage is 136k and swapped out portion of
> > > (in this case) mysqld process is 1.2g ?
> >
> > Welcome to OverCommit, aka OOM-nirvana.
> >
> > Try this:
> > # echo 2 > /proc/sys/vm/overcommit_memory
> > # echo 0 > /proc/sys/vm/overcommit_ratio
> >
> > But make sure you have enough swap.
> >
> >
> > Thanks!
>
> The swap cache looks pretty big, may be top is including that data
> while reporting swap usage.

I don't think so.  top reports correctly, it's the VM that is lying.
I guess you can tell what happens when push comes to shove...


Thanks!

--
Al

