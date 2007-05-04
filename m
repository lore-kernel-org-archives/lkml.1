Return-Path: <linux-kernel-owner+w=401wt.eu-S1767889AbXEDXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767889AbXEDXWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767901AbXEDXWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:22:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767889AbXEDXWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:22:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Date: Sat, 5 May 2007 01:19:17 +0200
User-Agent: KMail/1.9.6
Cc: john stultz <johnstul@us.ibm.com>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1178314144.6094.7.camel@localhost.localdomain> <20070504144408.c041d8df.akpm@linux-foundation.org>
In-Reply-To: <20070504144408.c041d8df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705050119.17234.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 23:44:08 Andrew Morton wrote:
> On Fri, 04 May 2007 14:29:04 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > One of the 2.6.21 regressions was Guilherme's problem seeing his box
> > lock up when the system detected an unstable TSC and dropped back to
> > using the HPET.
> > 
> > In digging deeper, we found the HPET is not actually incrementing on
> > this system. And in fact, the reason why this issue just cropped up was
> > because of Thomas's clocksource watchdog code was comparing the TSC to
> > the HPET (which wasn't moving) and thought the TSC was broken.
> > 
> > Anyway, Guliherme checked for a BIOS update and did not find one, so
> > I've added a DMI blacklist against his system so the HPET is not used.
> > 
> > Many thanks to Guilherme for the slow and laborious testing that finally
> > narrowed down this issue.
> > 
> 
> OK, I tagged that for -stable too.

Don't please. It is completely the wrong approach. DMI should be only last resort,
not first.

-Andi
