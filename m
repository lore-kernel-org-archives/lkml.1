Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYLaS1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYLaS1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYLaS13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:27:29 -0500
Received: from server.drzeus.cx ([85.8.24.28]:41288 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755921AbYLaS12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:27:28 -0500
Date: Wed, 31 Dec 2008 19:27:25 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28] mmc: warn about voltage mismatches
Message-ID: <20081231192725.1de9a8c6@mjolnir.drzeus.cx>
In-Reply-To: <200812310950.30478.david-b@pacbell.net>
References: <200812310950.30478.david-b@pacbell.net>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 09:50:30 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Get rid of a silent failure mode when the MMC/SD host doesn't
> support the voltages needed to operate a given card, by
> adding a warning.  A 3.3V host and a 3.0V card, for example,
> no longer need to mysteriously just not work at all.
> 

Hmm... I have sort of always assumed that 3.3V was always required by
the host and card, but re-reading the specs that clearly isn't the case.

> This isn't the best diagnostic; ideally it would also tell
> what voltage the card and host support (and not just by
> dumping the bitmasks).
> 

Still, it's better than nothing.

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Queued.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
