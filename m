Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZGHIJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZGHIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZGHIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:09:20 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:40280 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZGHIJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HEtTFZd2WZH0jzDGk6RtHHhRkBfKhvJwnKXiM9r1AR3TZdTkl197Nat5iBm61HxHad
         luu5vJpC4a2kpPmDQxI4QJuphynLKusataoh3PwC0mPo4KI07NePxM2w4/vmYEVY9A+w
         WQaEY40VPnmOWLp61Oq3jYFbCOLqgCwkGDFzs=
Date: Wed, 8 Jul 2009 10:08:52 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090708080852.GC3148@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <200907071534.07619.andres@anarazel.de> <20090707135742.GB6798@ami.dom.local> <200907071811.27570.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907071811.27570.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 06:11:27PM +0200, Andres Freund wrote:
> On Tuesday 07 July 2009 15:57:42 Jarek Poplawski wrote:
> > On Tue, Jul 07, 2009 at 03:34:07PM +0200, Andres Freund wrote:
> > ...
> > > Testing wether its triggerable inside a vm might be interesting...
> > Probably similarly to testing without this patch or even less. Maybe
> > I should've warned you but this type of bugs in -rc with possible
> > memory or stack overwrites might be fatal for your data (at least).
> Fortunately all the data on that machine should either be replaceable or 
> regularly backuped.
> 
> Will test later today if that patch bugs.

If you didn't start yet, it would be nice to use this, btw:

CONFIG_HOTPLUG_CPU = N
CONFIG_DEBUG_OBJECTS = Y
CONFIG_DEBUG_OBJECTS_TIMERS = Y

Thanks,
Jarek P.
