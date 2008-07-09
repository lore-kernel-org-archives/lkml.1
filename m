Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYGIE63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYGIE63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYGIE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:58:21 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37758 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354AbYGIE6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:58:21 -0400
Date: Wed, 9 Jul 2008 06:58:17 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: san@google.com (San Mehat)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] mmcblk: Fix deadlock when cleanup is called
 from resume
Message-ID: <20080709065817.10fc8736@mjolnir.drzeus.cx>
In-Reply-To: <20080708201011.GB16849@google.com>
References: <20080708201011.GB16849@google.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 13:10:11 -0700
san@google.com (San Mehat) wrote:

> 
>   When CONFIG_UNSAFE_RESUME is used, we may need to cleanup
>   (and call kthread_stop) when threads are still frozen. To fix this
>   deadlock, push cleanup off to a work-queue.
> 
>   Signed-off-by: San Mehat <san@android.com>
> 

I appreciate patches, but sending me something based on 2.6.21 is
hardly helpful. This particular problem was solved over a year ago in
mainline.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
