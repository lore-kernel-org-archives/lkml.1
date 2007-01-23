Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXAWS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXAWS45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965416AbXAWS44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:56:56 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:40995 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXAWS4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:56:55 -0500
Message-ID: <45B65A73.90308@drzeus.cx>
Date: Tue, 23 Jan 2007 19:56:51 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: au1xmmc R6 response support
References: <20070123100814.GA5001@roarinelk.homelinux.net>
In-Reply-To: <20070123100814.GA5001@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> Hi,
> 
> here's a trivial patch which adds R6 reponse support to the au1xmmc
> driver. Fixes SD card detection / operation.
> 

NAK. MMC_RSP_R1 and MMC_RSP_R6 have the same value so this will break
the switch.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
