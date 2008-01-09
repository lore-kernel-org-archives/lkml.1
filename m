Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYAIMtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYAIMtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYAIMs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:48:57 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45923 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYAIMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:48:56 -0500
Date: Wed, 9 Jan 2008 13:48:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6: ricoh_mmc woes
Message-ID: <20080109134852.5fc94c0b@poseidon.drzeus.cx>
In-Reply-To: <477FE882.1030901@t-online.de>
References: <477FE882.1030901@t-online.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jan 2008 21:28:50 +0100
Harald Dunkel <harald.dunkel@t-online.de> wrote:

> Hi folks,
> 
> I've got a problem with a Ricoh mmc reader. As soon as I insert a
> sd card I get tons of I/O errors. syslog says:
> 

You're getting some kind of bus transfer error. Did this work with 2.6.23?

Please enable CONFIG_MMC_DEBUG and include a copy of the output of dmesg.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
