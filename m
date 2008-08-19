Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYHSDMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYHSDMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHSDMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:12:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYHSDMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:12:36 -0400
Date: Mon, 18 Aug 2008 23:12:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Scott Wood <scottwood@freescale.com>, Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <1219114600.8062.15.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>  <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>  <48A9AFA7.8080508@freescale.com>  <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>  <1219110814.8062.2.camel@pasglop>
  <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>  <1219113549.8062.13.camel@pasglop> <1219114600.8062.15.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 Aug 2008, Benjamin Herrenschmidt wrote:

> Ok, so i did a patch, but it doesn't fix the problem. So
> there's something else whacking on the stack frames.

Is it 32 bit or 64?  I've tested the 64 bit quite a bit, but not so much 
the 32 (my powerbook is not usually that stable).

You might want to look at the entry.S mcount code too.

> 
> Still, here it is:

Thanks,

> 
> powerpc/ftrace: Fix broken assembly for code replacement
> 
> Instead, uses __get_user() and __put_user().
> 

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

