Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbYAFA6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbYAFA6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYAFA6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:58:39 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55636 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYAFA6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:58:38 -0500
Date: Sun, 6 Jan 2008 02:58:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106005807.GH22232@does.not.exist>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47802249.9010107@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:35:21AM +0100, Stefan Richter wrote:
> Adrian Bunk wrote:
> > Whether or not an option requires an additional subsystem like e.g. SCSI 
> > or SSB are hardware and implementation details we shouldn't bother 
> > kconfig users with.
> 
> What is an implementation detail and what is not?  In the end,
> everything that we configure in Kconfig is implementation details.

With the use case "system administrator" we can expect people to know 
the name of their ethernet card and which filesystems they use, but we 
should not bother them with the fact that their network card might 
require the Sonics Silicon Backplane support.

> PS:
> Kill 'select' already, and instead work on better UIs if you have got
> trouble with the complexities of the dependencies graph.  The graphic
> UIs including menuconfig currently work best for tree-like dependencies,
> but the graph isn't a tree.  Think about how to present this properly in
> an UI.  The Kconfig files are the wrong place to attack this problem.
>...

Duplicating the structure in each UI should be an improvement?

Hardly.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

