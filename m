Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYARMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYARMLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYARMLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:11:10 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58472 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYARMLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:11:09 -0500
Date: Fri, 18 Jan 2008 14:09:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118120958.GB19723@does.not.exist>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <1200653448.5724.135.camel@brick> <20080118113744.GA17447@uranus.ravnborg.org> <20080118120248.GA11044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080118120248.GA11044@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 01:02:48PM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > Style question, would the following be preferred?
> > > 
> > > config 64BIT
> > > 	def_bool ARCH = "x86_64"
> > > 	prompt "64-bit kernel"
> > > 	help...
> > 
> > No.
> > It is most common to let the prompt follow the type and not
> > as a separate property.
> 
> hm, ok. I guess there's not much cleanliness difference between:
> 
>     bool "64-bit kernel"
>     default ARCH = "x86_64"
> 
> and:
> 
>     def_bool ARCH = "x86_64"
>     prompt "64-bit kernel"

At least for me it's clear what the former does while I had to try the 
latter for understanding what it does exactly...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

