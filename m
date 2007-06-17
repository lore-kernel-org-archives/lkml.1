Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXFQE0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXFQE0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 00:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXFQEZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 00:25:58 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:55664 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbXFQEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 00:25:57 -0400
Date: Sat, 16 Jun 2007 22:30:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/5] Use EXTRARW_DATA in architectures
Message-ID: <20070617023010.GD6832@Krystal>
References: <20070615202959.316963297@polymtl.ca> <20070615203550.044690775@polymtl.ca> <20070615215534.GB11267@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070615215534.GB11267@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:29:44 up 19 days, 11:08,  3 users,  load average: 0.11, 0.10, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> Hi Mathieu.
> 
> On Fri, Jun 15, 2007 at 04:30:00PM -0400, Mathieu Desnoyers wrote:
> > EXTRARW_DATA adds a place to declare rw data that will not be mixed with the
> > .data content; therefore limiting data cache pollution when data is put in
> > the EXTRARW_DATA sections.
> 
> I would suggest to embed this inside DATA_DATA in vmlinux.lds.h
> That seems reasonsable to do instead of adding it right after DATA_DATA
> for all archs.
> 
Yes, it will be in my next release,

> From your patch it looks like I originally missed out
> powerpc + xtensa when introducing DATA_DATA - would be nice if
> you could fix that.
> 
> 	Sam

Done.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
