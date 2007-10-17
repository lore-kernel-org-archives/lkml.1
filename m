Return-Path: <linux-kernel-owner+w=401wt.eu-S1762097AbXJQTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbXJQTca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXJQTcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:32:22 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:32999 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbXJQTcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:32:22 -0400
Date: Wed, 17 Oct 2007 21:32:18 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Florin Malita <fmalita@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: possible leak in mmc_read_ext_csd
Message-ID: <20071017213218.28115e57@poseidon.drzeus.cx>
In-Reply-To: <4710F1E8.6090103@gmail.com>
References: <4710F1E8.6090103@gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 12:27:20 -0400
Florin Malita <fmalita@gmail.com> wrote:

> The exception path associated with an invalid ext_csd_struct returns 
> without freeing ext_csd.
> 
> Coverity CID 1909.
> 
> Signed-off-by: Florin Malita

Quite right. Applied.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
