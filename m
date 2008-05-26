Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYEZMTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYEZMTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYEZMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:19:35 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37165 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754871AbYEZMTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:19:34 -0400
Date: Mon, 26 May 2008 14:18:36 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080526141836.72db0623@mjolnir.drzeus.cx>
In-Reply-To: <20080523182834.GA469@polina.dev.rtsoft.ru>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	<20080523182834.GA469@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 22:28:34 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> ...so we'll able to write bindings for the OpenFirmware without
> messing with #ifdefs in the driver itself.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

This looks extremely wrong. Encapsulating probe functions isn't exactly
in line with the device model and bound to confuse people.

Your patches doesn't give a complete picture of the OF side of things,
but can't you solve this by having an init callback somewhere?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
