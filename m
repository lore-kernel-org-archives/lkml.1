Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZIRAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZIRAEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZIRAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:04:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45250 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZIRAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:04:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Sep 2009 09:02:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling v4
Message-Id: <20090918090200.a1810a9b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090917124039.GB9462@localhost>
References: <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917145319.97f67737.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917150726.9acb0f40.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917062124.GA6964@localhost>
	<20090917155100.3cc2dfb6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917071428.GA9232@localhost>
	<20090917162324.d60a7950.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917094203.GA13885@localhost>
	<b756a8e49c515a5ada93ac90d1076056.squirrel@webmail-b.css.fujitsu.com>
	<20090917124039.GB9462@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 20:40:39 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> > >         if (pos + count < pos)
> > >                 return -EOVERFLOW;
> > >         ...
> > > }
> > >
> > have to avoid pos == LONGLONGMAX case.
> 
> Ah sorry, didn't know loff_t could be long long..
> 
Thank you. I'll restart this after merge window.
(And maybe I had to CC fsdevel...)

Thanks,
-Kame

