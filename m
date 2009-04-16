Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZDPX7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZDPX7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZDPX64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:58:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53874 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZDPX6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:58:55 -0400
Date: Fri, 17 Apr 2009 08:57:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v2)
Message-Id: <20090417085720.1fc8cc86.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090416121407.GH7082@balbir.in.ibm.com>
References: <20090415120510.GX7082@balbir.in.ibm.com>
	<20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416015955.GB7082@balbir.in.ibm.com>
	<20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416121407.GH7082@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 17:44:07 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-16 16:40:36]:
> 
> > 2. In above, "mem" shouldn't be got from "mm"....please get "mem" from page_cgroup.
> > (Because it's file cache, pc->mem_cgroup is not NULL always.)
> > 
> > I saw this very easily.
> > ==
> > Cache: 4096
> > mapped_file: 20480
> > ==
> >
> 
> May I ask how and what was expected?
>  

Mapped_file <= Cache,

Thanks,
-Kame


> -- 
> 	Balbir
> 

