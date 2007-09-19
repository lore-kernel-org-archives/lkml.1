Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXISTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXISTcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbXISTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:32:00 -0400
Received: from vena.lwn.net ([206.168.112.25]:54968 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbXISTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:31:59 -0400
To: Andres Salomon <dilinger@queued.net>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] cafe_ccic: default to allocating DMA buffers at probe time 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 19 Sep 2007 01:44:18 EDT."
             <20070919014418.073543bc.dilinger@queued.net> 
Date: Wed, 19 Sep 2007 13:31:57 -0600
Message-ID: <11514.1190230317@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon <dilinger@queued.net> wrote:

> This patch makes DMA buffer allocation happen during device probe by
> default, and changes the parameter to 'alloc_bufs_at_read'.  The
> camera hardware is there, if the cafe_ccic driver is enabled/loaded it
> should do its best to ensure that the camera is actually usable;
> delaying DMA buffer allocation saves an insignicant amount of memory,
> and causes the driver to be much less useful.

The amount of memory isn't quite "insignificant" (three 640x480x2
buffers), but the OLPC people clearly need things to work this way.
There are, as far as I know, no other systems out there using the CAFE
controller.  Making things work by default for the one user (with a fair
number of deployed systems!) makes sense to me.  So...

  Acked-by: Jonathan Corbet <corbet@lwn.net>

That said, I do prefer the original name for the parameter.

jon

Jonathan Corbet / LWN.net / corbet@lwn.net


