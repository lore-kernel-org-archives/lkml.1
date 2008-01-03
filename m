Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYACRnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYACRnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYACRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:42:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:56085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYACRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:42:53 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 3 Jan 2008 18:42:49 +0100
User-Agent: KMail/1.9.6
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <200801031822.02668.rjw@sisk.pl>
In-Reply-To: <200801031822.02668.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031842.49668.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +config PM_CPUINIT
> > +	bool
> > +	depends on PM
> 
> Please make it PM_SLEEP (PM is more than suspend/hibernation).

That was something that irritated me too while writing the patch, but the functions I 
am interested in with this  are referenced from arch/x86/power/cpu.c and that is

obj-$(CONFIG_PM)                += cpu.o

So you would need to fix that first. Would be fine for me, but is out of scope for
my patch.

-Andi
