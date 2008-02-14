Return-Path: <linux-kernel-owner+w=401wt.eu-S1766011AbYBNUE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766011AbYBNUE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYBNUEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:04:14 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:57239 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758345AbYBNUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:04:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAIAttEdMQWYv/2dsb2JhbACSFZ0n
Date: Thu, 14 Feb 2008 15:04:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
Message-ID: <20080214200404.GA11166@Krystal>
References: <20080214034541.EF1BD270192@magilla.localdomain> <20080214132752.GA27478@Krystal> <20080214194633.GA21894@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080214194633.GA21894@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:02:57 up 3 days, 16:03,  6 users,  load average: 0.58, 0.32,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> On Thu, Feb 14, 2008 at 08:27:52AM -0500, Mathieu Desnoyers wrote:
> > * Roland McGrath (roland@redhat.com) wrote:
> > > 
> > > The samples/ subdirectory contains only modules.
> > > But the only make run done there is in commands for vmlinux.
> > > I can't see why this was ever done in this nonstandard fashion.
> > > As things stand, the modules don't get built by 'make modules'.
> > > 
> > > I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
> > > because there is no other conditional like that in the top-level Makefile
> > > and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
> > > always to be included.
> > > 
> > 
> > Sam, is this ok with the samples intent ? I think as long as we do not
> > include them with the kernel image and have a "make samples" to build
> > them, it's ok. Having them built upon make modules seems like a good
> > idea to me.
> 
> The samples code are supposed to be what the name says 'samples'.
> This is not code that are supposed to be part of the built-in kernel.
> This is not modules that are supposed to be installes when 
> installing modules.
> 
> Adding it to core-y as Roland does in the patch below is plain
> wrong as it enabled both points above.
> The fact that the present code in samples/ does not do this is
> in this respect irellevant.
> 
> Do we have problems when to build the sampls - then lets
> address this issue but not by trying to upgrade the samples
> to first class citizen in the kernel - they are not that
> and should not be handled like that.
> 

Then is there some other way to have the samples built upon "make
modules" that would not install them with other modules ?

Mathieu

> 	Sam

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
