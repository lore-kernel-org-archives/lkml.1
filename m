Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXFASMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXFASMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761731AbXFASMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:12:10 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:58415 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758653AbXFASMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:12:08 -0400
Date: Fri, 1 Jun 2007 14:06:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601180654.GB7641@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070601174510.GG7217@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:04:35 up 4 days,  2:43,  2 users,  load average: 0.84, 0.55, 0.48
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > It's not clear to me why either of those things are necessary. An
> > example please?
> 
> It's certainly possible that a global flag would need to be tested
> more than once.
> 
> I guess it would work if a symbol is associated with a single
> definition. e.g. if there is a DEFINE_COND_CALL() somewhere
> and the individual cond calls reference it.
> 

Yes, but as you have probably understood, I want to have everything
embedded at the cond_call() site rather than polluting the rest of the
code with declarations.

Also, if we have the same cond_calls in different modules, in which
module shall it be defined ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
