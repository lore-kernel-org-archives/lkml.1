Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYBUXzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYBUXzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935353AbYBUXzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:55:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36697 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964848AbYBUXzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:55:21 -0500
Date: Fri, 22 Feb 2008 00:55:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       John Stoffel <john@stoffel.org>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory
	controller in Kconfig
Message-ID: <20080221235527.GD25977@elf.ucw.cz>
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com> <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr> <20080220181911.GA4760@ucw.cz> <Pine.LNX.4.64.0802201927440.26109@fbirervta.pbzchgretzou.qr> <20080220185104.GA30416@elf.ucw.cz> <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  > >> For ordinary desktop people, memory controller is what developers
> >  > >> know as MMU or sometimes even some other mysterious piece of silicon
> >  > >> inside the heavy box.
> >  > >
> >  > >Actually I'd guess 'memory controller' == 'DRAM controller' == part of
> >  > >northbridge that talks to DRAM.
> >  >
> >  > Yeah that must have been it when Windows says it found a new controller
> >  > after changing the mainboard underneath.
> >
> >  Just for fun... this option really has to be renamed:
> 
> I think one reason of many people easy confusion is caused by bad menu
> hierarchy.
> I popose mem-cgroup move to child of cgroup and resource counter
> (= obey denend on).

> +config CGROUP_MEM_CONT
> +	bool "Memory controller for cgroups"

Memory _resource_ controller for cgroups?

> +	depends on CGROUPS && RESOURCE_COUNTERS
> +	help
> +	  Provides a memory controller that manages both page cache and

Same here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
