Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZB0IEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZB0IEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZB0IEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:04:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35520 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZB0IEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:04:32 -0500
Date: Fri, 27 Feb 2009 17:02:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] change cpuacct usage percpu format v2
Message-Id: <20090227170258.6598809e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830902262355i1a5d4040p53ad2274f783b5c0@mail.gmail.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830902262355i1a5d4040p53ad2274f783b5c0@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 23:55:06 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Feb 26, 2009 at 11:29 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > IIRC, there is physical cpu hotplug system and it can remove
> > cpus and change map. Considering a software which records
> > this information pediodically(like sar), its better to show id of cpu
> > in explict way.
> 
> Can we just use the read_map() handler for this instead?
> 
Ah, I forgeted that we have read_map handler.

Hmm...but read_map()'s fill handler format is "%s %llu\n"
For using read_map, I have to convert integer to string in this routine.

Will we add "%d:%llu\n" style fill() function ?

Thanks,
-Kame

