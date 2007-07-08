Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbXGHMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbXGHMXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXGHMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:23:29 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50225 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbXGHMX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:23:28 -0400
Date: Sun, 8 Jul 2007 14:23:25 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Cc: "Nobin Mathew" <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: platform_driver_register() ??
Message-ID: <20070708142325.479d380e@poseidon.drzeus.cx>
In-Reply-To: <4dde4acb0707050221k5a73a4abt2db9e8b0f7c74ae1@mail.gmail.com>
References: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
	<8d6898730707030558o5e110b0v257ffc6350c76069@mail.gmail.com>
	<20070703211513.5245946b@poseidon.drzeus.cx>
	<4dde4acb0707050221k5a73a4abt2db9e8b0f7c74ae1@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 14:51:35 +0530
"Midhun Agnihotram" <agnimidhun@gmail.com> wrote:

> 
>     Is it necessary that the firmware (may be bootloader) notify about
> the MMC host to Linux? The kernel documentation (platform.txt) says :
> 
>  "The firmware should notify the platform bus about devices before the
> legacy drivers have had a chance to load."
> 
>    Have I interpreted the above sentence correctly?
> 

I don't know what the meaning of that sentence was supposed to be, but
platform devices are everything the kernel cannot probe in a "normal"
way. Usually this covers devices that cannot be probed at all, but must
be listed some other way (i.e. manually).

Commonly the arch and machine specific code adds the devices. The
machine code is usually specific to a certain hardware, so the code
"knows" which devices are present, even though it can't probe them.

So to answer your question; no, the firmware doesn't have to tell Linux
about the devices.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
