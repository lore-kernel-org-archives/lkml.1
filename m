Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYKJHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYKJHER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYKJHEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:04:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49568 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYKJHEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:04:00 -0500
Date: Mon, 10 Nov 2008 16:03:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 5/6] memcg: mem+swap controller
Message-Id: <20081110160321.3ec35dd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081110133054.b090816c.nishimura@mxp.nes.nec.co.jp>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<20081105172316.354c00fb.kamezawa.hiroyu@jp.fujitsu.com>
	<20081110133054.b090816c.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 13:30:54 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > @@ -1062,13 +1208,55 @@ int mem_cgroup_resize_limit(struct mem_c
> >  			break;
> >  		}
> >  		progress = try_to_free_mem_cgroup_pages(memcg,
> > -				GFP_HIGHUSER_MOVABLE);
> > +				GFP_HIGHUSER_MOVABLE, false);
> >  		if (!progress)
> >  			retry_count--;
> >  	}
> >  	return ret;
> >  }
> >  
> mem_cgroup_resize_limit() should verify that mem.limit <= memsw.limit
> as mem_cgroup_resize_memsw_limit() does.
> 
> 
nice catch. will be fixed in the next version.

Thanks a lot!

-Kame

