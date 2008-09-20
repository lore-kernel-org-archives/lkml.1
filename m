Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYITLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYITLES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYITLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:04:04 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51498 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343AbYITLEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:04:02 -0400
Date: Sat, 20 Sep 2008 13:03:59 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_test: initialize mmc_test_lock statically
Message-ID: <20080920130359.61c6a916@mjolnir.drzeus.cx>
In-Reply-To: <20080913100331.GB3746@localhost.localdomain>
References: <20080913100331.GB3746@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 19:03:32 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> The mutex mmc_test_lock is initialized at every time mmc_test device
> is probed. Probing another mmc_test device may break the mutex, if
> the probe function is called while the mutex is locked.
> 
> This patch fixes it by statically initializing mmc_test_lock.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> ---

Also applied.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
