Return-Path: <linux-kernel-owner+w=401wt.eu-S1765434AbYDPRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434AbYDPRhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYDPRhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:37:39 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:59050 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136AbYDPRhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:37:39 -0400
Date: Wed, 16 Apr 2008 19:36:37 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make mmc_wait_for_app_cmd() static
Message-ID: <20080416193637.46772cde@mjolnir.drzeus.cx>
In-Reply-To: <20080413181555.GJ2182@cs181133002.pp.htv.fi>
References: <20080413181555.GJ2182@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 21:15:55 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global mmc_wait_for_app_cmd() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Now this one I'm going to have to NAK. We've discussed this one before
and I want to keep it around as part of the API so people don't go
doing silly reimplementations. The embedded crowd tends to work a bit
too much outside mainline, so I want to at least try to nudge them in
directions that keeps their code mergeable.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
