Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbYJTPjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbYJTPjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJTPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:38:53 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:53467 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYJTPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:38:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAEhC/EhMQWQ+/2dsb2JhbACBcsEgg2w
Date: Mon, 20 Oct 2008 11:38:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Breaks the redundant loop in kernel/marker.c
Message-ID: <20081020153850.GB27993@Krystal>
References: <48FC273B.3030300@cn.fujitsu.com> <20081020065205.GA12927@elte.hu> <48FC3083.8020104@cn.fujitsu.com> <20081020072520.GE12131@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081020072520.GE12131@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:37:45 up 137 days, 20:18,  9 users,  load average: 0.15, 0.35,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > hm, could you describe the necessity of this patch some more? This has 
> > > the change to change behavior, which might even be a bugfix: is there 
> > > any chance that the closure-loop in the e->ptype != NULL branch does not 
> > > exit? Before your patch we'd continue the iteration - which _probably_ 
> > > does not lead to any more matches (e->name is supposed to be unique).
> > 
> > Because e->name is unique in list, we don't need to continue the iteration
> > after matched.
> > This is a cleanup.
> 
> ok - it's useful to point this out in the changelog. You can use the 
> "Impact:" header we started using recently:
> 
>     Impact: cleanup, no functionality changed
> 
> See for example this upstream commit:
> 
> | commit 07454bfff151d2465ada809bbaddf3548cc1097c
> | Author: Thomas Gleixner <tglx@linutronix.de>
> | Date:   Sat Oct 4 10:51:07 2008 +0200
> |
> |     clockevents: check broadcast tick device not the clock events device
> |
> |     Impact: jiffies increment too fast.
>  
> Mathieu, any objections against the patch?
> 
> 	Ingo

It looks all good with an extended changelog.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
