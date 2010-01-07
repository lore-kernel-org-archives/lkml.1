Return-Path: <linux-kernel-owner+w=401wt.eu-S932434Ab0AGFzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0AGFzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161Ab0AGFzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:55:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46766 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0AGFzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:55:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 14:52:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm] build fix for
 memcg-move-charges-of-anonymous-swap.patch
Message-Id: <20100107145223.a73e2be9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107141401.6a182085.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
	<20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107141401.6a182085.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 14:14:01 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Anyway, I'm sorry that the first patch was wrong...
> This is the correct one.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> build fix in !CONFIG_SWAP case.
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c: In function 'is_target_pte_for_mc':
> mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
> make[1]: *** [mm/memcontrol.o] Error 1
> make: *** [mm] Error 2
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, maybe it's time to
  - remove EXPERIMENTAL from CONFIG_CGROUP_MEM_RES_CTRL_SWAP
and more,
  - remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP
    (to reduce complicated #ifdefs and replace them with CONFIG_SWAP.)

It's very stable as far as I test.

Thanks,
-Kame

