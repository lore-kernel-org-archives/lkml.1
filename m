Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0CIX7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:59:32 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44843 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab0CIX73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:59:29 -0500
Subject: Re: [PATCH 09/14] blackfin: Convert blackfin to use
 read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a1003091553j1f88ef69m748bf1ef54371c2f@mail.gmail.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
	 <8bd0f97a1003091553j1f88ef69m748bf1ef54371c2f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 15:59:24 -0800
Message-ID: <1268179164.3339.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 18:53 -0500, Mike Frysinger wrote:
> On Wed, Mar 3, 2010 at 22:57, John Stultz wrote:
> > This patch converts the blackfin architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.
> >
> > I have not built or tested this patch, so help from arch maintainers would be appreciated.
> 
> Blackfin builds & boots with generic clockevents and w/out
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Cool!

> did you want me to merge it for 2.6.35 or should it go through with
> your patchset ?

I'd say go ahead and merge it. 

thanks
-john




