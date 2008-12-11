Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYLKHao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYLKHao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYLKHag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:30:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38240 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYLKHaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:30:35 -0500
Date: Thu, 11 Dec 2008 16:29:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 3/3] CGroups: Add css_tryget()
Message-Id: <20081211162937.2829e625.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830812102328x52657bffm9864a0f9a4b3d5bd@mail.gmail.com>
References: <20081210233654.563182000@menage.corp.google.com>
	<20081210234432.407064000@menage.corp.google.com>
	<20081211141507.a087f270.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812102328x52657bffm9864a0f9a4b3d5bd@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 23:28:12 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Dec 10, 2008 at 9:15 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Could you add this ?
> > ==
> > bool    css_is_removed(struct cgroup_subsys_state *css)
> > {
> >        return test_bit(CSS_REMOVED, &css->flags);
> > }
> > ==
> > Then, I'll use this instead of memcg->obsolete flag.
> 
> I actually had a patch almost ready to send out the nuked memcg->obsolete.
> 
> A difference in mine is that I did
> 
> #define css_is_removed(__css) test_bit(CSS_REMOVED, &(__css)->css.flags)
> 
> so that you can use it on any subsystem state object that contains a
> "struct cgroup_subsys_state css;" field, which is currently all of
> them I think, without having to add the "->css" every time.
> 
ok, thx. very useful :)

-Kame

