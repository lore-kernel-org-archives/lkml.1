Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXIMCSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXIMCSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 22:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXIMCS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 22:18:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598AbXIMCS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 22:18:29 -0400
Date: Wed, 12 Sep 2007 19:17:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case
 MMCONFIG is used
Message-Id: <20070912191739.fc0e2554.akpm@linux-foundation.org>
In-Reply-To: <200709121921.43950.yinghai.lu@sun.com>
References: <200709121921.43950.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 19:21:43 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> +/**
> + * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
> + * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
> + * access it.  Maybe we don't have a way to generate extended config space
> + * accesses.   So check it
> + */

Please don't use the kerneldoc leadin "/**" for non-kerneldoc comments.
