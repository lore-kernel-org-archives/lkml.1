Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZLXACJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZLXACJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZLXACH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:02:07 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61746 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZLXACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:02:06 -0500
Date: Wed, 23 Dec 2009 16:00:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, eduard.munteanu@linux360.ro,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kmemtrace.txt question: kernel parameter(s)?
Message-Id: <20091223160050.0c282ad2.randy.dunlap@oracle.com>
In-Reply-To: <4B2AD38D.3070605@cn.fujitsu.com>
References: <20091217141342.9ae2072b.randy.dunlap@oracle.com>
	<4B2AD38D.3070605@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4B32AF5C.0164:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 08:57:49 +0800 Li Zefan wrote:

> Randy Dunlap wrote:
> > Hi,
> > 
> > Documentation/trace/kmemtrace.txt says:
> > 
> > Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
> > this? Should I worry?
> > A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
> > large the number is. You can fix it by supplying a higher
> > 'kmemtrace.subbufs=N' kernel parameter.
> > 
> > 
> > Where is this kernel parameter implemented and where is it documented?
> > or should this Answer just be fixed?
> > 
> 
> The whole documentation is out-dated. The original kmemtrace was based on
> relay, and then it moved to ftrace, without updating the documentation.

Thank you.  I guess that explains why kmemtraced (from kmemtrace-user.git)
fails with:
Could not open() file /sys/kernel/debug/kmemtrace/cpu0: No such file or directory

Eduard, can we get Documentation/trace/kmemtrace.txt updated, please?

---
~Randy
