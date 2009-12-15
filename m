Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZLOEjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZLOEjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZLOEjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:39:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33980 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZLOEjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:39:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 13:35:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v4.2
Message-Id: <20091215133546.6872fc4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
	<20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
	<20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com>
	<20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com>
	<20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com>
	<20091214171632.0b34d833.akpm@linux-foundation.org>
	<20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 20:30:37 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:
> >     2 ideas which I can think of now are..
> >     1) add sysctl_oom_calc_on_committed_memory 
> >        If this is set, use vm-size instead of rss.
> > 
> 
> I would agree only if the oom killer used total_vm as a the default, it is 
> long-standing and allows for the aforementioned capability that you lose 
> with rss.  I have no problem with the added sysctl to use rss as the 
> baseline when enabled.
> 
I'll prepare a patch for adds

  sysctl_oom_kill_based_on_rss (default=0)

ok ?

Thanks,
-Kame

