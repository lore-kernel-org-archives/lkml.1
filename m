Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZCBVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZCBVKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZCBVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:10:44 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46246 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZCBVKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:10:43 -0500
Date: Mon, 2 Mar 2009 22:10:39 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090302221039.608abe62@mjolnir.ossman.eu>
In-Reply-To: <1235392721-22545-2-git-send-email-apw@canonical.com>
References: <20090218205654.05896ece@mjolnir.ossman.eu>
	<1235392721-22545-2-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 12:38:41 +0000
Andy Whitcroft <apw@canonical.com> wrote:

> [Pierre, here is the updated version.  Got lost somewhere after testing
> and before sending out.]
> 
> Currently we are using an explicit udev rule to trigger loading of the
> mmc-block module when an MMC or SD card is detected:
> 
>     SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"
> 
> It makes much more sense for the mmc bus driver and the mmc-block module to
> share MODALIAS information so that they are linked automatically.
> 
> There is no real information of use in the MMC system at the current time.
> All devices inserted require us to load the mmc-block device.  Until such
> time as useful parameters exist simply reflect the module linkage via
> the module alias below:
> 
> 	mmc:block
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---

Queued, thanks.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
