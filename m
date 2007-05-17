Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXEQXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXEQXBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbXEQXB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:01:26 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37621 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406AbXEQXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:01:25 -0400
Message-ID: <464CDEAD.6090106@drzeus.cx>
Date: Fri, 18 May 2007 01:01:01 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tobias Bengtsson <tobbe@tobbe.nu>
CC: Philip Langdale <philipl@overt.org>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Add quirk to support polling for card presence
References: <46479D59.4020400@overt.org>
In-Reply-To: <46479D59.4020400@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias, did you test this patch and did it solve your problem?

Philip Langdale wrote:
> There is apparently at least one instance of the Ricoh SDHCI
> implementation out there where card insertion (and possibly
> removal) interrupts do not work - so the only way to detect
> a change in the presence of a card is to poll.
>
> This changes adds a polling quirk for the particular model
> reported by Tobias. The change is tentative as it assumes
> that removal interrupts do not work, but if they do work,
> then we can optimise things by not polling when there is
> a card present. So, it should not be committed until Tobias
> has confirmed the removal behaviour one way or the other and
> the change is accordingly updated.
>
> The polling frequency is 3 seconds because I've been running
> powertop and am paranoid about wakeups now. :-) I did some
> testing locally by masking out the interrupt events and 3
> seconds seems usable enough to me.
>
> Signed-off-by: Philip Langdale <philipl@overt.org>
>
>   

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

