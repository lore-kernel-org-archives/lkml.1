Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYFTRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYFTRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYFTRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:08:37 -0400
Received: from server.drzeus.cx ([85.8.24.28]:48621 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753568AbYFTRIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:08:37 -0400
Date: Fri, 20 Jun 2008 19:08:33 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: card test driver should not be builtin with other card
 support
Message-ID: <20080620190833.04e664d5@mjolnir.drzeus.cx>
In-Reply-To: <20080620110115.GB21835@fluff.org.uk>
References: <20080620105802.173598466@fluff.org.uk>
	<20080620110115.GB21835@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 12:01:15 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> On Fri, Jun 20, 2008 at 11:58:02AM +0100, ben@fluff.org.uk wrote:
> > The mmc test driver and mmc block driver will attempt to bind
> > to any card present in the system, which means only one of these
> > drivers will end up with the card. If either one of these is selected
> > as builtin, ensure the other does not get built.
> > 
> 
> This is what I would have liked to have done in Kconfig, but of course
> the system fails with a circular dependency error. Is there any way
> to get this done without some horrible hacks?
> 

AFAIK, you can manually control the driver binding using sysfs. Should
be solvable for the rootfs case using an initrd.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
