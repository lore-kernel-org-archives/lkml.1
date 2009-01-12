Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZALOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZALOoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZALOoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:44:06 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51692 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZALOoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:44:05 -0500
Date: Mon, 12 Jan 2009 15:43:57 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Yauhen Kharuzhy <jekhor@gmail.com>, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: [PATCH] s3cmci: Fix hangup in do_pio_write()
Message-ID: <20090112154357.4f4d4f48@mjolnir.drzeus.cx>
In-Reply-To: <1230808144-11166-1-git-send-email-jekhor@gmail.com>
References: <1230808144-11166-1-git-send-email-jekhor@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Jan 2009 13:09:04 +0200
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> This commit fixes the regression what was added by commit
> 088a78af978d0c8e339071a9b2bca1f4cb368f30 "s3cmci: Support transfers
> which are not multiple of 32 bits."
> 
> fifo_free() now returns amount of available space in FIFO buffer in
> bytes. But do_pio_write() writes to FIFO 32-bit words. Condition for
> return from cycle is (fifo_free() == 0), but when fifo has 1..3 bytes of
> free space then this condition will never be true and system hangs.
> 
> This patch changes condition in the while() to (fifo_free() > 3).
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>

Any objections here Ben? An Acked-by would be nice.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
