Return-Path: <linux-kernel-owner+w=401wt.eu-S1750988AbXBLAVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbXBLAVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXBLAVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:21:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45006 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988AbXBLAVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:21:10 -0500
Date: Mon, 12 Feb 2007 00:28:51 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212002851.3ca1b27a@localhost.localdomain>
In-Reply-To: <200702120004.15529.rjw@sisk.pl>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	<20070211194202.GC15445@elf.ucw.cz>
	<20070211210258.0b8da53c@localhost.localdomain>
	<200702120004.15529.rjw@sisk.pl>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +PM support:	Since Linux is used on many portable and desktop systems, your
> +		driver is likely to be used on such a system and therefore it
> +		should support basic power management by implementing, if
> +		necessary, the .suspend and .resume methods used during the
> +		system-wide suspend and resume transitions.  You should verify
> +		that your driver correctly handles the suspend and resume, but
> +		if you are unable to ensure that, please at least define the
> +		.suspend method returning the -ENOSYS ("Function not
> +		implemented") error.  Note, however, that in such a case your
> +		submission is likely to be suspended and only resumed when the
> +		driver correctly handles this feature.

I'd lose the last bit. Just end it at "error.", there are going to be
people who produce good reasons not to handle suspend/resume.
