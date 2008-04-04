Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYDDBOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYDDBOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbYDDBOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:14:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32833 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396AbYDDBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:14:03 -0400
Date: Fri, 4 Apr 2008 10:18:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, menage@google.com,
       xemul@openvz.org, skumar@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       rientjes@google.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup_disable=memory for 2.6.25?
Message-Id: <20080404101807.b9fa6a73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403134153.d7476dda.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0804032055590.8157@blonde.site>
	<47F53DA2.3050403@linux.vnet.ibm.com>
	<20080403134153.d7476dda.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 13:41:53 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 04 Apr 2008 01:57:14 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > I expected those patches to make it into 2.6.25.
> 
> My mind-ray receptors might need a tune-up.
> 
> > Could we please push these patches upstream before 2.6.25? Or is it too late?
> 
> Should be OK.  I borrowed a bit of Hugh's email and stuck it in the changelog
> so that it at least has some attempt to describe why it's an urgent change.

For example. Unix bench's execl test result on x86_64 was

== just after boot without mounting any cgroup fs.==
mem_cgorup=off : Execl Throughput       43.0     3150.1      732.6
mem_cgroup=on  : Execl Throughput       43.0     2932.6      682.0
==

I believe this is worth ot be urgent.

I'm now trying performance improvement patches but it's too late.

Thanks,
-Kame

