Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXENN4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXENN4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXENN4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:56:49 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59876 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbXENN4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:56:48 -0400
Message-ID: <46486A7F.8050705@drzeus.cx>
Date: Mon, 14 May 2007 15:56:15 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices
References: <464853D9.70904@drzeus.cx> <20070514123436.GB4095@ftp.linux.org.uk>
In-Reply-To: <20070514123436.GB4095@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, May 14, 2007 at 02:19:37PM +0200, Pierre Ossman wrote:
>
> First of all, please do not put patches in attachments.
>
>   

My mailer tends to fsck them up if I just paste them. And it's attached
without any base64 silliness, so most people can usually read it directly.

> As for the patch, an infinite loop is *much* worse than a panic.
> When one is installing a new kernel on remote box, having it
> booted with reboot on panic and loader falling back to old
> kernel on the next boot is a bloody good idea - gives you extra
> safety.  With your patch it will get the box stuck.
>   

Ok. So a timeout or having the entire thing Kconfig optional?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

