Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbXG0Oas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbXG0Oas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXG0Oaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:30:39 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36391 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394AbXG0Oai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:30:38 -0400
Date: Fri, 27 Jul 2007 16:30:35 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Investigating SD card failures
Message-ID: <20070727163035.4ec23c19@poseidon.drzeus.cx>
In-Reply-To: <20070727055026.GB27423@roarinelk.homelinux.net>
References: <20070727055026.GB27423@roarinelk.homelinux.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 07:50:26 +0200
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> Hi Pierre,
> 
> I have a 1GB SanDisk SD card here which linux does not recognize.
> Looking at the MMC debug output, I see the MMC core repeatedly
> issues CMD55/CMD41 commands (which all succeed!) then stops
> after 100 times.  In sd_ops.c the code checks for a bit to get set.
> My question is, what exactly is this bit supposed to indicate?
> 

That the card has initialized. Try extending the time that loop runs and see if the card powers up.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
