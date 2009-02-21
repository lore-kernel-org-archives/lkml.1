Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZBUQMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZBUQMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZBUQMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:12:03 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60577 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZBUQMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:12:01 -0500
Date: Sat, 21 Feb 2009 17:11:57 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: Re: [PATCH][take 2] MMC: core/core.c: fixed: delayed_work was never
 cancelled
Message-ID: <20090221171157.05fea20a@mjolnir.ossman.eu>
In-Reply-To: <1235042223-25586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
References: <20090218211945.669c3e95@mjolnir.ossman.eu>
	<1235042223-25586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 13:17:03 +0200
Jorg Schummer <ext-jorg.2.schummer@nokia.com> wrote:

> The delayed work item mmc_host.detect is now cancelled before flushing
> the work queue. This takes care of cases when delayed_work was scheduled
> for mmc_host.detect, but not yet placed in the work queue.
> 
> Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
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
