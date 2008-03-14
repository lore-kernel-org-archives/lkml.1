Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYCNWyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYCNWyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYCNWyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:54:45 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:40142 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYCNWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:54:45 -0400
Date: Fri, 14 Mar 2008 23:54:07 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: shri <shree0007@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc card detection
Message-ID: <20080314235407.5f4b241c@mjolnir.drzeus.cx>
In-Reply-To: <d65f34950803060539y284910bck277310280ef4c009@mail.gmail.com>
References: <d65f34950803060539y284910bck277310280ef4c009@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please always add the relevant maintainer as cc if you want to be sure
that you get a response.

On Thu, 6 Mar 2008 19:09:57 +0530
shri <shree0007@gmail.com> wrote:

> Hi,
>    My proto board does not have a mmc card detect line to the mmc controller.
> 
>    So, I have to insert the card before i insmod the mmc drivers.
>    If i change a card i have to rmmod and insmod the driver.
> 
>    I would like to know is there anyway i can make mmc to free up all the
>    resources for the removed card. entries and reinitialise the new
> card inserted if any
>    without rmmod or insmod.
> 

Let the driver call mmc_detect_change() on a timer. See mmci.c for an
example.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
