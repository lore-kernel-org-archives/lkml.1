Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZFMKqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZFMKqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZFMKqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:46:16 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47023 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbZFMKqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:46:15 -0400
Date: Sat, 13 Jun 2009 12:46:15 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Ramesh.R" <ramesh.kvp@gmail.com>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: SD Host Controller - over ride Linux native Drivers.
Message-ID: <20090613124615.59f2aeaf@mjolnir.ossman.eu>
In-Reply-To: <1e3142440906082342w2954f4fdje453f73da7da1681@mail.gmail.com>
References: <1e3142440906082339p33341dceuc2d324d8d21e6ac@mail.gmail.com>
	<1e3142440906082342w2954f4fdje453f73da7da1681@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 12:12:22 +0530
"Ramesh.R" <ramesh.kvp@gmail.com> wrote:

> How to over-ride the Linux - native Host controller driver to load and
> drive my development kit. Instead the auto load of native drivers, I
> want to use my drivers to test my development kit.
> 
> Please suggest us, if any of you faced like this and overcome this
> issue. I am appreciating your response.
> 

Just rmmod the drivers you don't want and insmod you drivers. They
should take over at that point. You can also blacklist the original
drivers to prevent them from ever being loaded. See the modprobe.conf
man page.

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
