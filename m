Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZELJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZELJbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbZELJat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:30:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45011 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759336AbZELJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:30:48 -0400
Date: Tue, 12 May 2009 10:31:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] input: use PIT_TICK_RATE in vt beep ioctl
Message-ID: <20090512103138.2675ca3f@lxorguk.ukuu.org.uk>
In-Reply-To: <200905112258.27662.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>
	<200905112258.27662.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch depends on "move PIT_TICK_RATE to linux/timex.h"
> in order to build on architectures that previously did not
> define PIT_TICK_RATE.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Alan Cox <alan@linux.intel.com>

I think this is probably the lesser of the evils here.
