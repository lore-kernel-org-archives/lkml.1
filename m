Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbZCaX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbZCaX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbZCaX6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:58:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56601 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZCaX6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:58:45 -0400
Date: Wed, 1 Apr 2009 08:57:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-Id: <20090401085710.d2f0b267.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49D20AE1.4060802@redhat.com>
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com>
	<1238457560-7613-2-git-send-email-ieidus@redhat.com>
	<1238457560-7613-3-git-send-email-ieidus@redhat.com>
	<1238457560-7613-4-git-send-email-ieidus@redhat.com>
	<1238457560-7613-5-git-send-email-ieidus@redhat.com>
	<20090331111510.dbb712d2.kamezawa.hiroyu@jp.fujitsu.com>
	<49D20AE1.4060802@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 15:21:53 +0300
Izik Eidus <ieidus@redhat.com> wrote:
> >   
> kpage is actually what going to be KsmPage -> the shared page...
> 
> Right now this pages are not swappable..., after ksm will be merged we 
> will make this pages swappable as well...
> 
sure.

> > If so, please
> >  - show the amount of kpage
> >  
> >  - allow users to set limit for usage of kpages. or preserve kpages at boot or
> >    by user's command.
> >   
> 
> kpage actually save memory..., and limiting the number of them, would 
> make you limit the number of shared pages...
> 

Ah, I'm working for memory control cgroup. And *KSM* will be out of control.
It's ok to make the default limit value as INFINITY. but please add knobs.

Thanks,
-Kame

