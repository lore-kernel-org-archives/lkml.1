Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYAOSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYAOSsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAOSsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:48:32 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43613 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYAOSsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:48:32 -0500
Date: Tue, 15 Jan 2008 20:47:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080115184729.GB19192@does.not.exist>
References: <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org> <20080115171146.GA2377@one.firstfloor.org> <20080115182142.GC18338@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080115182142.GC18338@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 07:21:42PM +0100, Sam Ravnborg wrote:
>...
> > > And I will add a config option to:
> > > - set -fno-unit-at-a-time
> > 
> > I was told future gcc versions would remove that. Why do you
> > want it?
> Are there any better way to tell gcc no to inline so agressively?

I haven't tested it, but -fno-inline-functions-called-once alone 
_might_ be enough.

> 	Sam

cu
Adrian

BTW: I hope it's clear for everyone that disabling such optimizations
     should only be used for debugging section mismatches, not for
     production kernels.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

