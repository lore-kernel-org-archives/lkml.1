Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXGXPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXGXPUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXGXPUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:20:23 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:47208 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbXGXPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:20:22 -0400
Date: Tue, 24 Jul 2007 11:20:18 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       jbeulich@novell.com, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected kernel text
Message-ID: <20070724152018.GA31729@Krystal>
References: <20070720532.949522000@suse.de> <20070720153246.6597614E79@wotan.suse.de> <1185257169.1803.213.camel@localhost.localdomain> <20070724135750.GD26634@Krystal> <46A61821.3070703@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46A61821.3070703@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:19:42 up 7 days,  9:53,  3 users,  load average: 0.56, 0.39, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
> > Hi Rusty,
> >
> > Good catch. I also still wonder why alternative (except alternative smp,
> > which is ok) and paravirt patching functions are not marked __init. I really
> > hope they are never used when NMI, MCE are enabled or when threads may
> > have been preempted in the site being patched, or it could result in an
> > illegal instruction.
> >   
> 
> We need to patch modules at load time.  Presumably an NMI/MCE handler
> will not depend on code in a being-loaded module.
> 
>     J
> 

Oh yes, I see. That's ok since the code of a being-loaded module is not
executed yet.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
