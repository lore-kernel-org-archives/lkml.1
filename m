Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbXKTREW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbXKTREW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXKTREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:04:14 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:56831 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619AbXKTREM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:04:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAM2iQkdMROHU/2dsb2JhbACBW48I
Date: Tue, 20 Nov 2007 12:04:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
Message-ID: <20071120170410.GC31044@Krystal>
References: <20071116200238.740495156@polymtl.ca> <20071117125007.GA4450@gollum.tnic> <20071119153139.GA24454@Krystal> <20071120051232.GA7210@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071120051232.GA7210@gollum.tnic>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:03:35 up 16 days, 22:09,  6 users,  load average: 0.64, 0.82,
	0.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Borislav Petkov (bbpetkov@yahoo.de) wrote:
> On Mon, Nov 19, 2007 at 10:31:39AM -0500, Mathieu Desnoyers wrote:
> > * Borislav Petkov (bbpetkov@yahoo.de) wrote:
> > > On Fri, Nov 16, 2007 at 03:02:38PM -0500, Mathieu Desnoyers wrote:
> > > Hi, 
> > > just a conventions proposal: have you thought of shortening all those
> > > "immediate_foo" prefixes to 'imm_foo', for example? This'll make the 
> > > code much more readable, i think.
> > > 
> > 
> > Hrm, a quick grep in the kernel tree shows me that the imm_* namespace
> > is already quite clobbered (although I do not detect any imm_read or
> > imm_set). 
> 
> Right, something called "low level driver for the IOMEGA MatchMaker"
> (drivers/scsi/imm.c) has gotten hold of the imm_* prefix already so there might
> be a problem later, probably. Nevertheless, you could use the imm_ prefix or
> choose some other 3-n letter prefix:
> 
> immed_* (3 matches)
> imme_* (no matches but dumb)
> imd_* (none!)
> immv_* (none, v like [v]alues), etc.
> ...
> 

I'd go for imv_* then, which indeed stands for "IMmediate Values"

> -- 
> Regards/Gruß,
>     Boris.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
