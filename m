Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZAEVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZAEVX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZAEVXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:23:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbZAEVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:23:14 -0500
Date: Mon, 5 Jan 2009 13:21:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
In-Reply-To: <20090105131350.66408a4f@infradead.org>
Message-ID: <alpine.LFD.2.00.0901051317450.3057@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain> <20090104103104.6fdda9f2@infradead.org> <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> <20090104110559.306186c4@infradead.org>
 <20090105162125.093b4adf@lxorguk.ukuu.org.uk> <20090105131350.66408a4f@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Arjan van de Ven wrote:
>
> ok I had that enabled somehow....

Well, it's not just "somehow".

It's the x86 def_config value, and it's also the default in at least the 
Fedora kernels.

Probably for a very good - although these days probably historical - 
reason: on older hardware, it really wasn't all that unusual to have the 
serial port at other interrupts.

And Alan may point to the help text, but that doesn't really matter since 
everybody clearly ignores it, and it's not what has been tested.

But yeah, we probably should disable it at least for modern machines. And 
even if it doesn't autodetect the irq, "setserial" hopefully still does 
work (and was always required for some machines anyway)

			Linus
