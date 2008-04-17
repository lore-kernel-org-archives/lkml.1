Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbYDQM4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbYDQM4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbYDQM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:56:08 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62327 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757251AbYDQM4H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:56:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloFAPrlBkhMROPA/2dsb2JhbACBYKs3
Date: Thu, 17 Apr 2008 08:56:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [RFC patch 15/27] Immediate Values - Documentation
Message-ID: <20080417125604.GA16219@Krystal>
References: <20080416213426.298498397@polymtl.ca> <20080416213552.942797527@polymtl.ca> <20080417184930.A8CD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080417103635.GG1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080417103635.GG1677@cs181133002.pp.htv.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:55:10 up 48 days,  9:06,  5 users,  load average: 0.43, 0.28,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> On Thu, Apr 17, 2008 at 06:52:54PM +0900, KOSAKI Motohiro wrote:
> > > +Memory read:
> > > +644.09ツア11.39 - 88.16ツア1.35 = 555.93ツア11.46 cycles
> > > +
> > > +Getppid without memory pressure:
> > > +1462.09ツア18.87 - 150.92ツア1.01 = 1311.17ツア18.90 cycles
> > > +
> > > +Getppid with memory pressure:
> > > +17113.33ツア1655.92 - 578.22ツア269.51 = 16535.11ツア1677.71 cycles
> > > +
> > > +Therefore, if we add 2 markers not based on immediate values to the getppid
> > > +code, which would add 2 memory reads, we would add
> > > +2 * 555.93ツア12.74 = 1111.86ツア25.48 cycles
> > 
> > sorry..
> > 
> > non ascii character is harmful for some language region user.
> > Couldn't you write ascii only?
> 
> The kernel is UTF-8, and this shouldn't be a problem.
> 
> The problem seems to be that Mathieu's emails don't contain a header 
> indicating the charset.
> 

I removed the UTF-8 characters for now. Someday I should fix my
quilt+exit4 setup, when I find the time. :)

Thanks,

Mathieu

> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
