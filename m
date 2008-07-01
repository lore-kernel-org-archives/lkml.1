Return-Path: <linux-kernel-owner+w=401wt.eu-S1764610AbYGAB56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764610AbYGAB56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbYGAB5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:57:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56917 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbYGAB5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:57:46 -0400
Subject: Re: [PATCH] Add btgpio driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
In-Reply-To: <200807010206.38714.mb@bu3sch.de>
References: <200807010206.38714.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:57:59 +0200
Message-Id: <1214877479.11537.101.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> This adds the btgpio driver.
> The purpose of the btgpio driver is to export all of the 24 GPIO pins
> available on Brooktree 8xx chips to the kernel GPIO infrastructure.
> 
> This makes it possible to use a physically modified BT8xx card as
> cheap digital GPIO card.

do you mind calling the driver bt8xxgpio. I am a little bit worried that
we otherwise clash with a potential Bluetooth GPIO driver at some point.
The new generation of generic Bluetooth drivers are using bt* as names
(like btsdio, btusb etc.).

Regards

Marcel


