Return-Path: <linux-kernel-owner+w=401wt.eu-S934734AbZDJQkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734AbZDJQkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZDJQkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:40:00 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35750 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZDJQj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:39:59 -0400
Date: Fri, 10 Apr 2009 18:39:55 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: Re: [PATCH 1/1] MMC: core/core.c: mmc_rescan detects card change in
 one run
Message-ID: <20090410183955.011c4d65@mjolnir.ossman.eu>
In-Reply-To: <1238511081-24570-1-git-send-email-ext-jorg.2.schummer@nokia.com>
References: <20090303095530.65923117@mjolnir.ossman.eu>
	<1238511081-24570-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:51:21 +0300
Jorg Schummer <ext-jorg.2.schummer@nokia.com> wrote:

> With this patch, mmc_rescan can detect the removal of an mmc card and
> the insertion of (possibly another) card in the same run. This means
> that a card change can be detected without having to call
> mmc_detect_change multiple times.
> 
> This change generalises the core such that it can be easily used by
> hosts which provide a mechanism to detect only the presence of a card
> reader cover, which has to be taken off in order to insert a card. Other
> hosts ("card detect" or "MMC_CAP_NEEDS_POLL") each receive an event when
> a card is removed and when a card is inserted, so it is sufficient for
> them if mmc_rescan handles only one event at a time. "Cover detect"
> hosts, however, only receive events about the cover status. This means
> that between 2 subsequent events, both a card removal and a card
> insertion can occur. In this case, the pre-patch version of mmc_rescan
> would only detect the removal of the previous card but not the insertion
> of the new card.
> 
> Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
> ---

Queued, thanks.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
