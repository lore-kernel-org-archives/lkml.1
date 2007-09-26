Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXIZWx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXIZWx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXIZWxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:53:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbXIZWxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:53:17 -0400
Date: Wed, 26 Sep 2007 15:52:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] usb_serial: Stop passing NULL to functions that expect
 data
Message-Id: <20070926155248.5e7df147.akpm@linux-foundation.org>
In-Reply-To: <20070926230840.231df58e@the-village.bc.nu>
References: <20070926230840.231df58e@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 23:08:40 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Earlier patches have removed the checking for old v new differences from
> the USB drivers so we can now pass in a valid blank old termios so that
> we don't to fill the drivers with magic hacks for console support

Are all the prerequisites for these patches in mainline, or are there
dependencies on -mm stuff here?
