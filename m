Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZGPW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZGPW4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933531AbZGPW4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:56:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:55015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933503AbZGPW4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:56:15 -0400
Date: Thu, 16 Jul 2009 15:55:25 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release()
 function, it is broken and must be fixed."
Message-ID: <20090716225525.GC1548@suse.de>
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:12:56PM +0200, Andreas Mohr wrote:
> Hi all,
> 
> got this when modprobing and then rmmoding my snd-azt3328 driver.
> 
> Then I decided to rmmod another soundcard, snd-als4000,
> with the same result.
> Trying to exclude any ALSA issues, I then unloaded parport_pc: same
> message.
> 
> The error happening _before_ module _init() and _after_ module _exit()
> clearly points to something outside of an individual driver's control,
> i.e. a module core code bug, as hinted by Greg.
> 
> x86_32 UP, Debian testing, module-init-tools 3.9-2, git as of yesterday.

I can't duplicate this here at all.  I wonder what the difference is.
No one has touched this code path in a while, any chance you could run
'git bisect' to track this down?

thanks,

greg k-h
