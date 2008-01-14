Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYANSSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYANSSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYANSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:18:11 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42878 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYANSSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:18:10 -0500
Date: Mon, 14 Jan 2008 20:17:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114181711.GA9847@does.not.exist>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080114145854.GA31695@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 03:58:54PM +0100, Ingo Molnar wrote:
>...
> a good way i see is to:
>...
>  - quickly reach a close-to-100%-perfect stage, brute-force. Drop 
>    __init* annotations en masse if they are not perfectly layered. 
>    Whoever reintroduces them will then have to do it perfectly.
>...

First of all, this would really hurt space limited systems.

And "whoever reintroduces them" will most likely mean in practice that 
some janitors will go through the code and you as a maintainer will 
anyway be busy with getting them in shape.

Let's get them rightonce and we have a reasonable status quo.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

