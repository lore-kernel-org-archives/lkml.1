Return-Path: <linux-kernel-owner+w=401wt.eu-S1762698AbYB0Xtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762698AbYB0Xtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYB0Xts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:49:48 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337AbYB0Xtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:49:47 -0500
Date: Wed, 27 Feb 2008 15:48:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com,
       avorontsov@ru.mvista.com, florian.fainelli@telecomint.eu
Subject: Re: [patch 2.6.25-rc2-git] gpio:  <linux/gpio.h> and "no GPIO
 support here" stubs
Message-Id: <20080227154854.6ee9432c.akpm@linux-foundation.org>
In-Reply-To: <200802221712.17815.david-b@pacbell.net>
References: <200802221712.17815.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 17:12:17 -0800
David Brownell <david-b@pacbell.net> wrote:

> Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on platforms
> that don't support the GPIO programming interface.  That includes the
> arch-specific implementation glue otherwise.
> 
> This facilitates a new model for GPIO usage:  drivers that can use GPIOs
> if they're available, but don't require them.  One example of such a
> driver is NAND driver for various FreeScale chips.  On platforms update
> with GPIO support, they can be used instead of a worst-case delay to
> verify that the BUSY signal is off.
> 
> (Also includes a couple minor unrelated doc updates.)
> 

Looks sane.

> Please include before 2.6.25-final ...

For what reason?
