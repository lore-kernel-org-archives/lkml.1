Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXKJW2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXKJW2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXKJW2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:28:47 -0500
Received: from znsun1.ifh.de ([141.34.1.16]:52849 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbXKJW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:28:47 -0500
Date: Sat, 10 Nov 2007 23:27:49 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
X-X-Sender: pboettch@pub2.ifh.de
To: Adrian Bunk <bunk@kernel.org>
Cc: Patrick Boettcher <pb@linuxtv.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: dib7000m_i2c_enumeration() is unused
In-Reply-To: <20071105170650.GF12045@stusta.de>
Message-ID: <Pine.LNX.4.64.0711102306020.11455@pub2.ifh.de>
References: <20071105170650.GF12045@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is another story of "the chip-vendor provides driver support and is 
waiting for device to hit the market". 

DiBcom knows that there are devices out there that are using the dib7000m 
in way that they need the dib7000m_i2c_enumeration to work properly. But 
it is impossible to know the devices in advance. This function is there 
for the case a user or developper needs it to add support for his board.

Patrick.

--
  Mail: patrick.boettcher@desy.de
  WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/




On Mon, 5 Nov 2007, Adrian Bunk wrote:

> dib7000m_i2c_enumeration() is currently unused, but although I don't 
> understand the code I have a gut feeling it should have been used in 
> dib0700_devices.c. Is this correct?
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

