Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZCDA23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZCDA23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCDA2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:28:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52823 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZCDA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:28:19 -0500
Date: Wed, 4 Mar 2009 09:26:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       lizf@cn.fujitsu.cn, menage@google.com
Subject: Re: + cgroup-memcg-show-correct-file-mode.patch added to -mm tree
Message-Id: <20090304092656.fe02dc51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090303075828.GA10019@elte.hu>
References: <200902262100.n1QL0Vvi021877@imap1.linux-foundation.org>
	<20090303075828.GA10019@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 08:58:28 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
> >  		.name = "usage_in_bytes",
> >  		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
> >  		.read_u64 = mem_cgroup_read,
> > +		.mode = 0444
> 
> Uhm, we've got symbols for permission bits for a reason. 
> (S_IRUGO in this case)
> 
> > +		.mode = 0444
> 
> Ditto.
> 
> > +		.mode = 0200
> 
> Ditto. (S_IWUSR)
> 
> > +		.mode = 0444
> 
> Ditto.
> 
ok, will post a replacement.

Thank you for pointing out.
-Kame

> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

