Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYJQAbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYJQAbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYJQAbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:31:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44595 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYJQAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:31:10 -0400
Date: Fri, 17 Oct 2008 09:30:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2008-10-16-00-52 uploaded (cgroup + mm)
Message-Id: <20081017093046.80ae7d14.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0810161400230.14604@shark.he.net>
References: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810161400230.14604@shark.he.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 14:01:48 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 16 Oct 2008, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-10-16-00-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27:
> 
> 
> build-r9168.out:(.text+0x261e6): undefined reference to `lookup_page_cgroup'
> build-r9168.out:memcontrol.c:(.text+0x2629f): undefined reference to `lookup_page_cgroup'
> build-r9168.out:memcontrol.c:(.text+0x2671a): undefined reference to `lookup_page_cgroup'
> build-r9168.out:(.text+0x268f9): undefined reference to `lookup_page_cgroup'
> build-r9168.out:memcontrol.c:(.text+0x26e52): undefined reference to `page_cgroup_init'
> build-r9168.out:(.text+0x26f44): undefined reference to `lookup_page_cgroup'
> build-r9168.out:(.init.text+0xe42): undefined reference to `pgdat_page_cgroup_init'
> 
> 
> .config is at http://oss.oracle.com/~rdunlap/kerneltest/configs/config-r9168
> 
Ouch...

Hmm....it seems

memcg-allocate-all-page_cgroup-at-boot.patch doesn't includes changes to Makefile...

Thank you for report. I'll send a fix soon.

Regards,
-Kame



