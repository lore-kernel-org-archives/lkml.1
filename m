Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYKNIHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYKNIHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYKNIHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:07:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57838 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYKNIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:07:22 -0500
Date: Fri, 14 Nov 2008 17:06:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
Message-Id: <20081114170637.7cc50951.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491D30E5.7080608@linux.vnet.ibm.com>
References: <20081113164201.GV29067@bolzano.suse.de>
	<20081113191837.18ed2ade.akpm@linux-foundation.org>
	<491CF609.3050203@cn.fujitsu.com>
	<20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>
	<491D2C21.5000600@linux.vnet.ibm.com>
	<20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
	<491D2E6C.1000009@cn.fujitsu.com>
	<491D30E5.7080608@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 13:33:49 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Li Zefan wrote:
> >>>> +static int mem_cgroup_size(void)
> >>> inline this function?
> >>>
> >> necessary ? 
> >>
> > 
> > Not so necessary IMO. It's called when a cgroup is created and removed, that
> > is mkdir and rmdir, where performance is not critical.
> > 
> 
> I think most new compilers can automatically inline such functions, but a hint
> for the older ones is always a good practice.
> 

Adding "inline" is easy. But, IMHO, adding "inline" to not-performance-critical part
is just confusing people.
I want to see "inline" where inline is obviously good/necessary for performance.

Thanks,
-Kame

