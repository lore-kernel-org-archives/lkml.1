Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXEGOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXEGOSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXEGOSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:18:50 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1279 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbXEGOSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:18:49 -0400
Date: Mon, 7 May 2007 18:18:33 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: interrupt trigger flags from IRQ resource
Message-ID: <20070507141833.GA10829@zarina>
Reply-To: cbou@mail.ru
References: <20070507134906.GA26296@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070507134906.GA26296@fluff.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 01:49:06PM +0000, Ben Dooks wrote:
> At least one driver (drivers/net/dm9000.c) could
> do with being able to configure the trigger type
> of the IRQ depending on the system it is connected
> to. There are two methods for this, and requesting
> comments on these solutions.
> 
> 1) The platform data supplied with the device
>    carries an unsigned long field with the
>    IRQF_TRIGGER_xxx for the system.
> 
> 2) The driver convers the flags passed in the
>    IORESOURCE_IRQ into an IRQF_TRIGGERR_xxx.

Um.. isn't the similar thing was naked some time ago?

http://lkml.org/lkml/2007/4/16/240

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
