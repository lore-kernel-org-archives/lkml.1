Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238Ab0AGLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0AGLXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056Ab0AGLXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:23:20 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:39136 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0AGLXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:23:19 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Thu, 7 Jan 2010 20:23:35 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: How should we handle CONFIG_CGROUP_MEM_RES_CTRL_SWAP (Re: [PATCH
 -mmotm] build fix for memcg-move-charges-of-anonymous-swap.patch)
Message-Id: <20100107202335.c18b728b.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100107145223.a73e2be9.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
	<20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107141401.6a182085.nishimura@mxp.nes.nec.co.jp>
	<20100107145223.a73e2be9.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Changed the subject and Cc list)

On Thu, 7 Jan 2010 14:52:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> BTW, maybe it's time to
>   - remove EXPERIMENTAL from CONFIG_CGROUP_MEM_RES_CTRL_SWAP
> and more,
>   - remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP
>     (to reduce complicated #ifdefs and replace them with CONFIG_SWAP.)
> 
> It's very stable as far as I test.
> 
I agree on both.

Balbir-san, What do you think ?
