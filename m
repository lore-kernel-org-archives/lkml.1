Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbXEUSoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbXEUSoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbXEUSn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:43:59 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53560 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXEUSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:43:59 -0400
Message-ID: <4651E866.5010304@drzeus.cx>
Date: Mon, 21 May 2007 20:43:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
In-Reply-To: <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>
> Do you have a fixed set of attribute names, where you just want to
> create a subset from that matches the individual device, or do you
> need some sort of free naming for the attributes?
>

Currently, the names are fixed (and I don't see any pressing need for
having dynamic names). I do want to have the ability to add attributes
in different parts of the code though since it allows me to group the
sysfs stuff closer to the function it accesses.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

