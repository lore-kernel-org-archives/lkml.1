Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717Ab0AGEe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0AGEe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599Ab0AGEeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:34:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58041 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab0AGEeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:34:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 13:31:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm] build fix for
 memcg-improve-performance-in-moving-swap-charge.patch
Message-Id: <20100107133110.16d2c4ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107130631.144750c3.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130631.144750c3.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 13:06:31 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> build fix in !CONFIG_CGROUP_MEM_RES_CTLR_SWAP case.
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c: In function 'mem_cgroup_move_charge_pte_range':
> mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
> mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
> mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
> make[1]: *** [mm/memcontrol.o] Error 1
> make: *** [mm] Error 2
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

