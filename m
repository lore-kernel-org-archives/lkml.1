Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXHJB4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXHJB4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbXHJB4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:56:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758424AbXHJB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:56:12 -0400
Date: Thu, 9 Aug 2007 18:55:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: YOSHIFUJI Hideaki / =?UTF-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, devel@openvz.org,
       adobriyan@sw.ru, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
Message-Id: <20070809185521.c3ab1afd.akpm@linux-foundation.org>
In-Reply-To: <20070810.104710.28739250.yoshfuji@linux-ipv6.org>
References: <m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.104710.28739250.yoshfuji@linux-ipv6.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 10:47:10 +0900 (JST) YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> wrote:

> Hello.
> 
> In article <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com> (at Thu, 09 Aug 2007 18:56:09 -0600), ebiederm@xmission.com (Eric W. Biederman) says:
> 
> > 
> > - In ipv6 ndisc_ifinfo_syctl_change so it doesn't depend on binary
> >   sysctl names for a function that works with proc.
> > 
> > - In neighbour.c reorder the table to put the possibly unused entries
> >   at the end so we can remove them by terminating the table early.
> > 
> > - In neighbour.c kill the entries with questionable binary sysctl
> >   handling behavior.
> > 
> > - In neighbour.c if we don't have a strategy routine remove the
> >   binary path.  So we don't the default sysctl strategy routine
> >   on data that is not ready for it.
> > 
> 
> I disagree.  It is bad to remove existing interface.

But it is good to remove bad interfaces, if we possibly can.

It is worth making the attempt.  Does anyone know of anything which will
break?  I fed NET_NEIGH_ANYCAST_DELAY at random into
http://www.google.com/codesearch and came up with nothing...


