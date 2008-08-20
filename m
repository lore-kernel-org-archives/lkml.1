Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYHTSeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYHTSeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYHTSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:34:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYHTSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:33:59 -0400
Date: Wed, 20 Aug 2008 14:33:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eran Liberty <liberty@extricom.com>
cc: Jon Smirl <jonsmirl@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Alan Modra <amodra@au1.ibm.com>,
       Scott Wood <scottwood@freescale.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <48AC6120.1080400@extricom.com>
Message-ID: <alpine.DEB.1.10.0808201431140.3035@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <1219114600.8062.15.camel@pasglop>  <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>  <1219119431.8062.35.camel@pasglop> <1219216705.21386.46.camel@pasglop>  <alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com>
  <alpine.DEB.1.10.0808200916090.13132@gandalf.stny.rr.com>  <48AC1DD8.9080702@extricom.com>  <alpine.DEB.1.10.0808200941560.13132@gandalf.stny.rr.com>  <48AC23F4.80900@extricom.com> <9e4733910808200755y1128ae56p6a1235684bfbb3ec@mail.gmail.com>
 <48AC6120.1080400@extricom.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Eran Liberty wrote:
> mon> X
> ~ #
> 
> And took it for a test drive
> ~# while [ 1 ] ; do find / > /dev/null ; echo .  ; done
> .
> .
> .
> [ 10 min later ]
> .
> .
> .
> 
> Stable! Yeepee.

Eran, thanks a lot for testing this!

> 
> So how do we get this to be right in the first place and everywhere?
> 

This is a bug in gcc, and should be mentioned to the gcc maintainers.

-- Steve

