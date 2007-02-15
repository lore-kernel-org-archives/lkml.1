Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbXBNXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbXBNXVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXBNXVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:21:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57262 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343AbXBNXVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:21:17 -0500
Date: Thu, 15 Feb 2007 00:24:57 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akennedy@techmoninc.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial console issues.
Message-ID: <20070215002457.7b382d5f@localhost.localdomain>
In-Reply-To: <20070214161114.bfc52cea95091b0fffcb409eab6296ba.39d16a8e24.wbe@email.secureserver.net>
References: <20070214161114.bfc52cea95091b0fffcb409eab6296ba.39d16a8e24.wbe@email.secureserver.net>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 16:11:14 -0700
akennedy@techmoninc.com wrote:

> In a previous post I incorrectly stated that my serial port is a
> TI16750, as this is what /proc/tty/... revealed to me.  After
> re-reading the product manual, I see that this is actually a 16550. 
> Since Linux is seeing this port as a 16750, could that explain why I'm
> seeing missing characters in the transmission.  After doing some
> research, I found that the 16750 has a 64-byte buffer, whereas I know
> this to only have a 16-byte buffer.

The autodetect is pretty solid so you may well find the chip is 16750
compatible, 16550A is what is usually listed because it is what people
look for.

> If my assumptions are correct and Linux is detecting this serial port
> incorrectly, how can I force the serial driver to see this a 16550?

man setserial
