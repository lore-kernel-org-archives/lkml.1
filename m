Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYBLMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYBLMYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYBLMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:23:58 -0500
Received: from gra-lx1.iram.es ([150.214.224.41]:55804 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYBLMX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:23:57 -0500
X-Greylist: delayed 2081 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 07:23:57 EST
From: Gabriel Paubert <paubert@iram.es>
Date: Tue, 12 Feb 2008 12:49:05 +0100
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other goodies
Message-ID: <20080212114905.GA9940@iram.es>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <1202460043.7079.157.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202460043.7079.157.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 07:40:43PM +1100, Benjamin Herrenschmidt wrote:
> 
> On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > - couple of fixes and preparatory patches
> > 
> > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> 
> Interesting... I was thinking about doing a full remove of the device at
> a higher level instead but I suppose what you propose is easier.

Well, I have serious problem on a Pegasos which appeared some time
between 2.6.24 and 2.6.25-rc1: at boot I get an infinite string of 

hdb: empty DMA table?

I'm trying to bisect it right now.

	Gabriel


> 
> I'll have a look & test next week hopefully.
> 
> Ben.
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
