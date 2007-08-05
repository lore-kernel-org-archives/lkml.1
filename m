Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXHERD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXHERD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXHERDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:03:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXHERDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:03:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
Date: Sun, 5 Aug 2007 19:12:17 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee> <200708050010.19338.rjw@sisk.pl> <Pine.SOC.4.64.0708051217340.11960@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708051217340.11960@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051912.17342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 August 2007 11:18, Meelis Roos wrote:
> > > This is arcch/ppc:
> > > 
> > > kernel/power/Kconfig:84:warning: 'select' used by config symbol 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> > 
> > May I see .config please?
> 
> Oops, sorry, should have sent along with the warning. And it's arch/ppc, 
> not the new arch/powerpc.

Hmm, with this .config SUSPEND_SMP cannot be set, because SMP is unset in it.

Can you please check if this warning is still present with the patch from
http://marc.info/?l=linux-kernel&m=118633307113052&w=2 applied?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
