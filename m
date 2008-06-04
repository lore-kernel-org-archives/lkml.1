Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYFDG6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYFDG6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYFDG6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:58:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53769 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYFDG6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:58:36 -0400
Date: Wed, 4 Jun 2008 16:03:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
Message-Id: <20080604160356.f3f2488d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48463C14.4000705@cn.fujitsu.com>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
	<48463C14.4000705@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 14:54:12 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > Index: temp-2.6.26-rc2-mm1/Documentation/controllers/resource_counter.txt
> > ===================================================================
> > --- temp-2.6.26-rc2-mm1.orig/Documentation/controllers/resource_counter.txt
> > +++ temp-2.6.26-rc2-mm1/Documentation/controllers/resource_counter.txt
> > @@ -44,6 +44,13 @@ to work with it.
> >   	Protects changes of the above values.
> >  
> >  
> > + f. struct res_counter *parent
> > +
> > +	Parent res_counter under hierarchy.
> > +
> > + g. unsigned long long for_children
> > +
> > +	Resources assigned to children. This is included in usage.
> 
> Since parent and for_children are also protected by res_count->lock,
> the above text should appear before 'e. spinlock_t lock'.
> 
ok.

Thanks,
-Kame

