Return-Path: <linux-kernel-owner+w=401wt.eu-S937816AbZAPWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937816AbZAPWRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764133AbZAPWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:17:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761328AbZAPWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:17:21 -0500
Date: Fri, 16 Jan 2009 14:15:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, prarit@redhat.com, dhowells@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, sam@ravnborg.org, kyle@mcmartin.ca,
       tony.luck@intel.com, trond.myklebust@fys.uio.no
Subject: Re: linux-next: build problem with nfs tree (Was: Re:
 [mmotm][PATCH] fix ia64 build error)
Message-Id: <20090116141557.0a3eaaac.akpm@linux-foundation.org>
In-Reply-To: <20090116153417.891297ca.sfr@canb.auug.org.au>
References: <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090115093514.f3f6b8ff.akpm@linux-foundation.org>
	<20090116124949.7828a559.sfr@canb.auug.org.au>
	<20090115175917.8e0ae536.akpm@linux-foundation.org>
	<20090116134930.68e783aa.sfr@canb.auug.org.au>
	<20090116153417.891297ca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 15:34:17 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> With the help of Paul Mackerras, I have come up with the shell script
> below.  You run it with the commit id, the tag of the tree you care
> about (e.g. next-20080115)(it defaults to the current top of tree) and
> the name of the branch the represents Linus' tree (default to
> origin/master).  It will spit out the (or a) tree that contains the
> commit you asked about.

hm.  Thanks.

y:/usr/src/git26> git-checkout linux-next
Switched to branch "linux-next"
y:/usr/src/git26> who-committed.sh ba9a5918
y:/usr/src/git26> who-committed.sh 2c3fb6b1b1a43ca089032e6523207f6687c962c1
y:/usr/src/git26> 
