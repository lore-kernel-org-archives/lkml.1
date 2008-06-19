Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYFSCdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYFSCdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 22:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYFSCd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 22:33:27 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34096 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYFSCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 22:33:26 -0400
Date: Thu, 19 Jun 2008 11:30:58 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: support checking of subsystem dependencies
Message-Id: <20080619113058.aba69cbf.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <4859AAF8.9060909@cn.fujitsu.com>
References: <4858C0ED.2080905@cn.fujitsu.com>
	<20080619091714.320fdaa6.kamezawa.hiroyu@jp.fujitsu.com>
	<4859AAF8.9060909@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 08:40:24 +0800, Li Zefan <lizf@cn.fujitsu.com> wrote:
> KAMEZAWA Hiroyuki wrote:
> > On Wed, 18 Jun 2008 16:01:49 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> This allows one subsystem to require that it only be mounted when some
> >> other subsystems are also present in the proposed hierarchy.
> >>
> >> For example if subsystem foo depends on bar, the following will fail:
> >>  # mount -t cgroup -ofoo xxx /dev/cgroup
> >>
> >> You should mount with both subsystems:
> >>  # mount -t cgroup -ofoo,bar xxx /dev/cgroup
> >>
> > I'm just curious. May I ask "Is there such cgroup subsystem now ?"
> > 
> 
> Currently no, but people who are developing or wants to develop new subsystems
> may find this useful, for example Daisuke Nishimura-san's swap controller.
> 
My current version is implemented as addon to memory controller,
so it can be used by just mounting memory controller :)

But anyway, this feature might be used in future by some subsystems.


Thanks,
Daisuke Nishimura.

