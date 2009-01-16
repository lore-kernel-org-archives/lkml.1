Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbZAPWxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbZAPWxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbZAPWxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:53:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757831AbZAPWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:53:01 -0500
Date: Fri, 16 Jan 2009 14:51:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, prarit@redhat.com, dhowells@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, sam@ravnborg.org, kyle@mcmartin.ca,
       tony.luck@intel.com, trond.myklebust@fys.uio.no
Subject: Re: linux-next: build problem with nfs tree (Was: Re:
 [mmotm][PATCH] fix ia64 build error)
Message-Id: <20090116145156.ebbea173.akpm@linux-foundation.org>
In-Reply-To: <20090117094008.5a0ce562.sfr@canb.auug.org.au>
References: <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090115093514.f3f6b8ff.akpm@linux-foundation.org>
	<20090116124949.7828a559.sfr@canb.auug.org.au>
	<20090115175917.8e0ae536.akpm@linux-foundation.org>
	<20090116134930.68e783aa.sfr@canb.auug.org.au>
	<20090116153417.891297ca.sfr@canb.auug.org.au>
	<20090116141557.0a3eaaac.akpm@linux-foundation.org>
	<20090117094008.5a0ce562.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009 09:40:08 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 16 Jan 2009 14:15:57 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > y:/usr/src/git26> git-checkout linux-next
> > Switched to branch "linux-next"
> > y:/usr/src/git26> who-committed.sh ba9a5918
> 
> Well that commit is from 2.6.23-rc1:
> 
> commit ba9a5918c86762fa7fae353c635bb6ed5221dfb8
> Author: Douglas Thompson <dougthompson@xmission.com>
> Date:   Thu Jul 19 01:50:32 2007 -0700
> 
>     drivers/edac: add to maintainers new info
> 
> before linux-next even existed.  My script only works for things in
> linux-next but not in Linus' tree ...
> 
> > y:/usr/src/git26> who-committed.sh 2c3fb6b1b1a43ca089032e6523207f6687c962c1
> 
> And that is one I committed myself because Linus' tree is broken.

Oh, OK, sorry, drat.  Two hastily and poorly chosen test cases.

> I'll see if I can do better.  What do you actually want to do?

y:/usr/src/git26> who-committed.sh bcff57c25287216221d0ff82080ac37bb081969e
ide

That ;)
