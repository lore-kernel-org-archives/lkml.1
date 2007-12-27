Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXL0Rut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXL0Rut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXL0Rul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:50:41 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44672 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXL0Ruk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:50:40 -0500
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 12:50:40 EST
Date: Thu, 27 Dec 2007 19:21:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mxser, remove it
Message-ID: <20071227172101.GA18199@does.not.exist>
References: <1198762722-3222-1-git-send-email-jirislaby@gmail.com> <4773C283.5070408@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4773C283.5070408@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 06:19:31PM +0300, Michael Tokarev wrote:
> Jiri Slaby wrote:
> > (Old) mxser is obsoleted by mxser_new and scheduled for removal on Dec 2007.
> > Remove it.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > ---
> >  Documentation/feature-removal-schedule.txt |    8 -
> >  drivers/char/Kconfig                       |   11 -
> >  drivers/char/Makefile                      |    1 -
> >  drivers/char/mxser.c                       | 3141 ----------------------------
> >  drivers/char/mxser.h                       |  441 ----
> >  5 files changed, 0 insertions(+), 3602 deletions(-)
> >  delete mode 100644 drivers/char/mxser.c
> >  delete mode 100644 drivers/char/mxser.h
> 
> While we're at it, how about adding a modalias for mxser_new
> module with old (being removed) name, so that users who're
> using the old module will not scream?  I mean, in order for
> `modprobe mxser' to load mxser_new module.

It might even make sense to rename the mxser_new module to mxser and do 
it the other way round - it's e.g. not clear whether a _new driver is 
for new hardware or a new driver for old hardware.

> /mjt

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

