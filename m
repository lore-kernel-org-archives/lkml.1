Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYFDJ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYFDJ1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFDJ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:27:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50344 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYFDJ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:26:59 -0400
Date: Wed, 4 Jun 2008 18:31:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
Message-Id: <20080604183157.d6d1289d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830806040215j4f49483bnfa474eb27120a5e3@mail.gmail.com>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830806040159o648392a1l3dbd84d9c765a847@mail.gmail.com>
	<20080604181528.f4c94743.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830806040215j4f49483bnfa474eb27120a5e3@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 02:15:32 -0700
"Paul Menage" <menage@google.com> wrote:

> On Wed, Jun 4, 2008 at 2:15 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> Should we try to support hierarchy and non-hierarchy cgroups in the
> >> same tree? Maybe we should just enforce the restrictions that:
> >>
> >> - the hierarchy mode can't be changed on a cgroup if you have children
> >> or any non-zero usage/limit
> >> - a cgroup inherits its parent's hierarchy mode.
> >>
> > Ah, my patch does it (I think).  explanation is bad.
> >
> > - mem cgroup's mode can be changed against ROOT node which has no children.
> > - a child inherits parent's mode.
> 
> But if it can only be changed for the root cgroup when it has no
> children, than implies that all cgroups must have the same mode. I'm
> suggesting that we allow non-root cgroups to change their mode, as
> long as:
> 
> - they have no children
> 
> - they don't have any limit charged to their parent (which means that
> either they have a zero limit, or they have no parent, or they're not
> in hierarchy mode)
> 
Hmm, I got your point. Your suggestion seems reasonable.
I'll try that logic in the next version.

Thanks,
-Kame

