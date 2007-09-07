Return-Path: <linux-kernel-owner+w=401wt.eu-S965439AbXIGMYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439AbXIGMYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 08:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965099AbXIGMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 08:23:58 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46857 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965239AbXIGMX6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 08:23:58 -0400
Date: Fri, 7 Sep 2007 08:23:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] Immediate Values - Documentation
Message-ID: <20070907122353.GB9735@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200316.343198308@polymtl.ca> <20070906142033.c0047718.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070906142033.c0047718.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:21:58 up 39 days, 12:40,  3 users,  load average: 1.60, 1.29, 1.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
[fixing the rest of the comments in the patch]
> What character is this that I cannot read (not displayed properly
> by my email client maybe)?  <something> after 644.09 and before the
> +- symbol, repeated just before all of the +- symbols.
> 

This file seems to be UTF-8 and the mail has been send by quilt. Is it
ok or should I change this to +/- just to make sure ?


> 
> > +Getppid without memory pressure:
> > +1462.09±18.87 - 150.92±1.01 = 1311.17±18.90 cycles
> > +
> > +Getppid with memory pressure:
> > +17113.33±1655.92 - 578.22±269.51 = 16535.11±1677.71 cycles
> > +
> > +Therefore, if we add 2 markers not based on immediate values to the getppid
> > +code, which would add 2 memory reads, we would add
> > +2 * 555.93±12.74 = 1111.86±25.48 cycles
> > +
> > +Therefore,
> > +
> > +1111.86±25.48 / 16535.11±1677.71 = 0.0672
> > + relative error: sqrt(((25.48/1111.86)^2)+((1677.71/16535.11)^2))
> > +                     = 0.1040
> > + absolute error: 0.1040 * 0.0672 = 0.0070
> > +
> > +Therefore: 0.0672±0.0070 * 100% = 6.72±0.70 %
> > +
> > +We can therefore affirm that adding 2 markers to getppid, on a system with high
> > +memory pressure, would have a performance hit of at least 6.0% on the system
> > +call time, all within the uncertainty limits of these tests. The same applies to
> > +other kernel code paths. The smaller those code paths are, the highest the
> > +impact ratio will be.
> > +
> > +Therefore, not only is it interesting to use the immediate values to dynamically
> > +activate dormant code such as the markers, but I think it should also be
> > +considered as a replacement for many of the "read mostly" static variables.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
