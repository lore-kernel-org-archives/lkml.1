Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZCHNll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZCHNll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 09:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZCHNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 09:41:33 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:52933 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZCHNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:41:32 -0400
Date: Sun, 8 Mar 2009 14:41:28 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Green <andy@openmoko.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmc: During unsafe resume, select the right volatge for
 the card
Message-ID: <20090308144128.03fab50d@mjolnir.ossman.eu>
In-Reply-To: <20090225095806.GB3217@fedora.yogi>
References: <20090209132806.GD3278@fedora.yogi>
	<20090218212515.6bae1bf6@mjolnir.ossman.eu>
	<20090225095806.GB3217@fedora.yogi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 15:28:09 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> On Wed, Feb 18, 2009 at 09:25:15PM +0100, Pierre Ossman wrote:
> > On Mon, 9 Feb 2009 18:58:08 +0530
> > Balaji Rao <balajirrao@openmoko.org> wrote:
> > 
> > > When mmc_power_up is called during unsafe resume, host->ocr should be
> > > used instead of host->ocr_avail.
> > > 
> > > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > > Cc: Andy Green <andy@openmoko.com>
> > > Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> > > ---
> > 
> > Hmm... This is a bit hackish and changes the previously known behaviour
> > of mmc_power_up(). We probably need to refactor things and have some
> > other explicit call from the resume path.
> > 
> 
> Hi Pierre,
> 
> Here's a simpler patch. How does this look ? 
> 

Should work. Queued up.

Thanks
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
