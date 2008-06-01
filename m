Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYFAKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYFAKXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 06:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYFAKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 06:23:43 -0400
Received: from server.drzeus.cx ([85.8.24.28]:42371 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751457AbYFAKXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 06:23:42 -0400
Date: Sun, 1 Jun 2008 12:23:36 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/3] mmc: add support for card-detection polling
Message-ID: <20080601122336.71915642@mjolnir.drzeus.cx>
In-Reply-To: <20080523154340.GA24862@polina.dev.rtsoft.ru>
References: <20080523154204.GA19803@polina.dev.rtsoft.ru>
	<20080523154340.GA24862@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 19:43:40 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Some hosts (and boards that use mmc_spi) do not use interrupts on the CD
> line, so they can't trigger mmc_detect_change. We want to poll the card
> and see if there was a change. 1 second poll interval seems resonable.
> 
> This patch also implements .get_cd() host operation, that could be used
> by the hosts that are able to report card-detect status without need to
> talk MMC.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

Applied the whole lot. Thanks. :)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
