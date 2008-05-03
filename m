Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYECMGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYECMGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYECMGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:06:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46428 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbYECMGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:06:23 -0400
Date: Sat, 03 May 2008 21:05:15 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@gmail.com>,
       Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: powerpc boot regression
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1209653507.27240.7.camel@badari-desktop>
References: <20080501051304.GM20457@bakeyournoodle.com> <1209653507.27240.7.camel@badari-desktop>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080503205334.9A1A.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Thu, 2008-05-01 at 15:13 +1000, Tony Breeds wrote:
> > On Tue, Apr 29, 2008 at 11:12:41PM -0700, David Miller wrote:
> > > 
> > > This commit causes bootup failures on sparc64:
> > > 
> > > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > Date:   Mon Apr 28 02:13:33 2008 -0700
> > > 
> > >     memory hotplug: allocate usemap on the section with pgdat
> > 
> > 
> > <snip>
> > 
> > We're seeing a boot failure on powerpc.  git bisect points the problem
> > at this commit.   However reverting just this one comitt doesn't fix the
> > regression.  I also needed to revert
> > 04753278769f3b6c3b79a080edb52f21d83bf6e2 (memory hotplug: register
> > section/node id to free")
> > 
> > Problem seen on power4, power5 and ps3.
> 
> I don't see the problem on my power5 machine. Can you send the
> config ? Is CONFIG_SPARSEMEM_VMEMMAP enabled ?
> 
> Please let me know.

I heard sparc has the similar regression.

http://marc.info/?l=linux-kernel&m=120953950332044&w=2

If Kame-san's temporary patch fixes your problems, its cause may be same.


Thanks.

-- 
Yasunori Goto 


