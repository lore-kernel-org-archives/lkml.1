Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYBRUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYBRUu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYBRUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:50:47 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:39872 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYBRUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:50:46 -0500
Date: Mon, 18 Feb 2008 21:50:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Laszlo Attila Toth <panther@balabit.hu>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: keyboard dead with 45b5035
Message-ID: <20080218215012.0462a302@mjolnir.drzeus.cx>
In-Reply-To: <200802182050.01964.rjw@sisk.pl>
References: <20080218185305.48a67587@mjolnir.drzeus.cx>
	<200802182050.01964.rjw@sisk.pl>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 20:50:01 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 18 of February 2008, Pierre Ossman wrote:
> > The patch "[RTNETLINK]: Send a single notification on device state changes." kills (at least)
> > the keyboard here. Everything seems to work fine in single user mode, but when init starts
> > spawning of logins, the keyboard goes bye-bye. Even the power button is ignored. :/ 
> 
> Please try with the patch from http://lkml.org/lkml/2008/2/18/331 .
> 

That solved it.

I wonder if that's also why modprobe tends to wedge up with the new USB announce thingy... Tomorrow's debugging will tell.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
