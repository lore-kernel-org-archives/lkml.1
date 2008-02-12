Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYBLMaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYBLMaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYBLMaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:30:08 -0500
Received: from gra-lx1.iram.es ([150.214.224.41]:36541 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYBLMaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:30:07 -0500
From: Gabriel Paubert <paubert@iram.es>
Date: Tue, 12 Feb 2008 13:30:03 +0100
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other goodies
Message-ID: <20080212123002.GA11000@iram.es>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <1202460043.7079.157.camel@pasglop> <20080212114905.GA9940@iram.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212114905.GA9940@iram.es>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:49:05PM +0100, Gabriel Paubert wrote:
> On Fri, Feb 08, 2008 at 07:40:43PM +1100, Benjamin Herrenschmidt wrote:
> > 
> > On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > - couple of fixes and preparatory patches
> > > 
> > > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> > >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> > 
> > Interesting... I was thinking about doing a full remove of the device at
> > a higher level instead but I suppose what you propose is easier.
> 
> Well, I have serious problem on a Pegasos which appeared some time
> between 2.6.24 and 2.6.25-rc1: at boot I get an infinite string of 
> 
> hdb: empty DMA table?
> 
> I'm trying to bisect it right now.

Argh, the first bisect point ended up with timeouts on hdb...

Flagged as bad, to try to see when the problems started, but 
I suspect that there are several.

	Gabriel
