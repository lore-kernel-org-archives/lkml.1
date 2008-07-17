Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYGQQWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYGQQWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYGQQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:22:45 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39925 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbYGQQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:22:45 -0400
Date: Thu, 17 Jul 2008 18:22:42 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: MMC: s3cmci: ensure host stopped on machine shutdown
Message-ID: <20080717182242.598ff68a@mjolnir.drzeus.cx>
In-Reply-To: <20080717155037.GI24620@fluff.org.uk>
References: <20080717143253.823429733@fluff.org.uk>
	<20080717172945.3481eefa@mjolnir.drzeus.cx>
	<20080717155037.GI24620@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:50:37 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> On Thu, Jul 17, 2008 at 05:29:45PM +0200, Pierre Ossman wrote:
> > 
> > The core can send requests your way until mmc_remove_host() returns so
> > you can't remove the interrupt before then.
> 
> I'm only removing the card-detect interrupt, the main host one
> is not being disabled here.
> 

Ah, I see. Then it should be just fine. I'll have it queued up.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
