Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXAYAjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXAYAjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAYAjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:39:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34284 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXAYAjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:39:18 -0500
Date: Thu, 25 Jan 2007 09:32:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: clameter@sgi.com, aubreylee@gmail.com, svaidy@linux.vnet.ibm.com,
       nickpiggin@yahoo.com.au, rgetz@blackfin.uclinux.org,
       Michael.Hennerich@analog.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070125093259.74f76144.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070124141510.7775829c.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	<20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0701232028520.6820@schroedinger.engr.sgi.com>
	<20070124141510.7775829c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 14:15:10 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>   And...some customers want to keep memory Free as much as possible.
>   99% memory usage makes insecure them ;)
> 
If there is a way that the "free" command can show "never used" memory,
they will not complain ;).

But I can't think of the way to show that.
==
[kamezawa@aworks src]$ free
            total       used       free     shared    buffers     cached
Mem:        741604     724628      16976          0      62700     564600
-/+ buffers/cache:      97328     644276
Swap:      1052216       2532    1049684
==

If anyone has some good idea, could you teach me ?

Regards,
-Kame

