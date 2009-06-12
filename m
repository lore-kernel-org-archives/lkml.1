Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbZFLHXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbZFLHXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZFLHXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:23:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZFLHXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:23:42 -0400
Message-ID: <4A3202D5.3050307@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 15:25:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
References: <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com> <4A3143E3.3090705@kernel.org> <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI> <20090611214342.GA12762@elte.hu> <20090611220307.GA16180@elte.hu> <20090612071703.GA29679@elte.hu>
In-Reply-To: <20090612071703.GA29679@elte.hu>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Plus i quickly got this crash too:
> 
> [    0.000000] console [tty0] enabled
> [    0.000000] allocation of page_cgroup was failed.
> [    0.000000] please try cgroup_disable=memory boot option
> [    0.000000] Kernel panic - not syncing: Out of memory
> [    0.000000] Rebooting in 1 seconds..<1>BUG: unable to handle kernel NULL pointer dereference at 0000004c
> [    0.000000] IP: [<c16ec708>] klist_next+0x10/0x8f
> [    0.000000] *pdpt = 0000000001a8a001 *pde = 0000000000000000 
> [    0.000000] Thread overran stack, or stack corrupted
> 
> crash-log and config attached.
> 

reported and fixed:

http://marc.info/?l=linux-kernel&m=124478832620049&w=2

Pekka will push the fix to Linus.
