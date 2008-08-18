Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbYHRT3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbYHRT3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764245AbYHRT2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39505 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbYHRT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:28:44 -0400
Date: Mon, 18 Aug 2008 15:28:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Scott Wood <scottwood@freescale.com>
cc: Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <48A9C5C0.5010705@freescale.com>
Message-ID: <alpine.DEB.1.10.0808181528030.796@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181445160.796@gandalf.stny.rr.com>
 <48A9C5C0.5010705@freescale.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Aug 2008, Scott Wood wrote:

> Steven Rostedt wrote:
> > What syntax to do that with?
> > 
> >   lwz %1,0(%U2)
> >   stu %3, 0(%X2)
> > 
> > I'm new to those. (and the above does not compile)
> 
> lwz%U2%X2 %1, %2
> stw%U2%X2 %3, %2

Thanks, that's new to me.

> 
> > > Why stwu with an offset of zero,
> > 
> > How else to do it?  stwu %3, (%2) does not compile for me.
> 
> stw %3, 0(%2)
> 
> The "u" tells it to write the effective address back to %2 -- but with an
> offset of zero, the effective address is unchanged.

Ah! Right!

/me should open up his PowerPC ref books again :-p

-- Steve

