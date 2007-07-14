Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbXGNP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbXGNP1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXGNP1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:27:37 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:49100 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753690AbXGNP1h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:27:37 -0400
Date: Sat, 14 Jul 2007 11:27:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 4/8] Immediate Value - Add kconfig menus
Message-ID: <20070714152734.GB4737@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca> <20070714072801.GB5822@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070714072801.GB5822@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:22:55 up 7 days,  5:28,  2 users,  load average: 0.58, 0.29, 0.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Fri, Jul 13, 2007 at 09:24:43PM -0400, Mathieu Desnoyers wrote:
> > Immediate values provide a way to use dynamic code patching to update variables
> > sitting within the instruction stream. It saves caches lines normally used by
> > static read mostly variables.
> 
> >  kernel/Kconfig.immediate |   11 +++++++++++
> 
> NAK, if this immediate stuff is so super-cool¹ it should be default on.
> 
> ¹ it isn't
> 

Hi Alexey,

On embedded systems, the tradeoff is not the same. The immediate values
trade a little bit of system memory (to keep the pointers to the
variable and instruction as well as the size of the variable, only used
when the variable is updated) in order to remove cache line hot paths.

Also, embedded systems with physically read-only memory clearly does not
want to enable this.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
