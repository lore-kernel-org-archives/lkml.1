Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIIIvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIIIvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIIIvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:51:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZIIIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:51:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090909084751.GC24614@csn.ul.ie>
References: <20090909165706.0CFE.A69D9226@jp.fujitsu.com> <20090909084751.GC24614@csn.ul.ie>
Message-Id: <20090909175036.0D06.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 17:51:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 09, 2009 at 05:17:34PM +0900, KOSAKI Motohiro wrote:
> > > On Wed, Sep 09, 2009 at 09:49:15AM +0900, KOSAKI Motohiro wrote:
> > > > Hi
> > > > 
> > > > This release doesn't boot on my ia64 test box.
> > > > After following two patches reverted, booting was successful.
> > > > 
> > > > 	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
> > > > 	Kamezawa-san's kcore patch series
> > > > 
> > > > 
> > > > Mel, Kamezawa-san, Can you please gime me any advise?
> > > 
> > > Can you post a .config, the vanilla dmesg, the dmesg with the page
> > > allocator patch reverted, the dmesg with Kamezawa-san's patch reverted
> > > and both reverted please?
> > 
> > I already attached .config on another mail.
> > if neither of either revert, the system become hang before output any dmesg.
> 
> console=uart,io,0x3f8 ?
> 
> I'm trying to resurrect an ia-64 machine here to reproduce the problem but
> it's in bad shape :(

I use "console=tty0 console=ttyS0". but serial console also do no output ;)



> > if both reverted, the sysmtem output the attached dmesg.
> > 
> 
> 
> 
> > Thanks.
> 
> 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab



