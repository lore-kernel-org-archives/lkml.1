Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZAYPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZAYPtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZAYPtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:49:05 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34955 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZAYPtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:49:04 -0500
Date: Sun, 25 Jan 2009 16:48:58 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090125164858.6b281c6c@mjolnir.drzeus.cx>
In-Reply-To: <ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	<20090112160519.3ba21848@mjolnir.drzeus.cx>
	<20090115150003.GB6896@shadowen.org>
	<20090124185612.5afddbb0@mjolnir.drzeus.cx>
	<ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 00:45:46 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sat, Jan 24, 2009 at 18:56, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> >
> > Well, as long as we're on the track of temporary hack, we might as well
> > just export "mmc_block" as the modalias. Or would there be any
> > side-effects to that?
> 
> The common format is to prefix with "<subsystem>:". Something like
> "mmc:block" sounds fine to me.
> 

My point was to have the kernel explicitly ask for the module it wants
as there is no decent device to driver mapping scheme.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
