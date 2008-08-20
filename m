Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbYHTOXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbYHTOXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYHTOWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:22:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYHTOWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:22:52 -0400
Date: Wed, 20 Aug 2008 10:22:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Alan Modra <amodra@au1.ibm.com>,
       Scott Wood <scottwood@freescale.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       segher@kernel.crashing.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <1219241819.26429.24.camel@jdub.homelinux.org>
Message-ID: <alpine.DEB.1.10.0808201022080.23571@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>  <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>  <48A9AFA7.8080508@freescale.com>  <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>  <1219110814.8062.2.camel@pasglop>
  <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>  <1219113549.8062.13.camel@pasglop> <1219114600.8062.15.camel@pasglop>  <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>  <1219119431.8062.35.camel@pasglop> <1219216705.21386.46.camel@pasglop>
  <alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com> <1219241819.26429.24.camel@jdub.homelinux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Josh Boyer wrote:
> 
> Segher was looking at this a bit this morning.  He thinks it's really
> -fno-omit-frame-pointer that is causing this.  That really shouldn't
> even be set on PowerPC, but FTRACE uses select which overrides the
> depends on stuff in Kconfig.

I can easily make a patch that makes that select an x86 only.

-- Steve

