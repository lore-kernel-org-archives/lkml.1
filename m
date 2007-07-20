Return-Path: <linux-kernel-owner+w=401wt.eu-S938768AbXGTPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938768AbXGTPvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936907AbXGTPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:51:06 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43361 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761865AbXGTPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:51:05 -0400
Date: Fri, 20 Jul 2007 17:50:57 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/mmc/core/: make 4 functions static
Message-ID: <20070720175057.20838321@poseidon.drzeus.cx>
In-Reply-To: <20070716023345.GO3565@stusta.de>
References: <20070712235602.GV3492@stusta.de>
	<20070715185234.584f7e1c@poseidon.drzeus.cx>
	<20070716023345.GO3565@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 04:33:46 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> 
> If mmc_start_request() is considered part of an API people should
> use, why isn't there a prototype in a header file?
> 

Just goes to show how much I know. ;)

So I guess we can privatize that one. But I'd still like to keep
mmc_wait_for_app_cmd().

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
