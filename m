Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbYBLVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbYBLVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760092AbYBLVAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:00:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:49198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbYBLVA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:00:29 -0500
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other
	goodies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gabriel Paubert <paubert@iram.es>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20080212114905.GA9940@iram.es>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
	 <1202460043.7079.157.camel@pasglop>  <20080212114905.GA9940@iram.es>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 07:59:52 +1100
Message-Id: <1202849992.7410.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 12:49 +0100, Gabriel Paubert wrote:
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

Pegasos doesn't use the pmac ide which is what we were discussing. It
uses a VIA IDE which uses a normal PRD table. So something else must
have broken...

Ben.


