Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbYFDUX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbYFDUX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYFDUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:23:49 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55637 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912AbYFDUXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:23:48 -0400
Date: Wed, 4 Jun 2008 23:23:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604202314.GG4189@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com> <20080604191522.GA18873@uranus.ravnborg.org> <4846EBAE.2000604@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4846EBAE.2000604@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 12:23:26PM -0700, Tim Bird wrote:
> Sam Ravnborg wrote:
> >> I can do a more controlled comparison if you're interested.
> > 
> > What would be really useful would be to do some king of automated
> > monitoring of the size of individual parts of the kernel in
> > a few controlled configs.
> > And then as son as somethings grows with > 1% for example then to
> > bring this to lkml.
> > Doing this based on linux-next would allow us to catch the bloaters
> > while they are still or just have been doing certain changes.
> > 
> > It would be nice to tell someone that just enabled som new gcc option
> > that this had a cost of 163.432 bytes with a certain config.
> > This would get attraction and be dealt with.
> 
> This is something I've wanted to get done for the last few
> years.  We've crept towards it slowly with things like bloatwatch
> and some of the automated testing CELF did for it's (currently
> temporarily defunct) test lab.
> 
> But we've never gotten to the last bit, which is to fully automate
> the testing at the top of tree, and send notifications.  I won't
> make any promises, but this is something CELF is very interested in,
> and we have parts of the required software already written.

I might be wrong, but although monitoring the size makes a lot of sense
I don't believe "fully automate the testing ... and send notifications" 
will work.

Like the CONFIG_LOG_BUF_SHIFT example from my last email you can easily 
get huge differences in a defconfig that do not indicate any problem at 
all, and I'd expect you'll need frequent finetuning of the .config's 
used. And if there's a problem you'll have to identify what exactly 
causes the problem.

But if CELF has resources then doing this kind of stuff IMHO makes
more sense than adding a config option for each 5kB of code
(and also has better long-term effects).

>  -- Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

