Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZE2HIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZE2HIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZE2HHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:07:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56255 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZE2HHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:07:41 -0400
Date: Fri, 29 May 2009 16:06:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Maximum size of a swap partition
Message-Id: <20090529160607.db4d55b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090529154701.8edf2deb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090528093117.87b190ed.Christoph.Pleger@cs.tu-dortmund.de>
	<20090529083054.d0cb6622.Christoph.Pleger@cs.tu-dortmund.de>
	<20090529154701.8edf2deb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 15:47:01 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:


> I'm not sure whether there are other limitations. But maybe enough big.
> 
I missed the another story.

For managing swap, the kernel uses 2bytes per 1 swap entry.
Then, if swap parttion is 1Gbytes, the kernel uses 512k bytes of memory.

in x86, this memory is allocated from vmalloc() area (you can see it in meminfo)
and it has only 80?MB. And there are other users of this area.

Then, in real x86-32bit world, you can't use verrrrry big swap device.

Then, 16GB=8MB in the kernel (or some more) is realistic limitation for usual
users.

Thanks,
-Kame

