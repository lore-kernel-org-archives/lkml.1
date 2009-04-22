Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZDVIXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZDVIXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZDVIWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:22:44 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47994 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZDVIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:22:43 -0400
Date: Wed, 22 Apr 2009 09:22:16 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422082216.GA31246@shareable.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <20090421063549.3b71881d@infradead.org> <20090421135034.GA30114@elte.hu> <20090421140533.GA6375@shareable.org> <20090421142627.GA18129@elte.hu> <20090421153745.2d8964c7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421153745.2d8964c7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> To start with there is no reason that the
> USB console can't implement a "maybe we have hardware, maybe I buffer 64K
> until it shows up" behaviour and bind to hardware as and when USB serial
> devices get inserted.

Ah, that doesn't work, when you want to use the USB serial console
_if_ there's a USB serial adapter plugged in, and a different (lower
priority) console if it's not.

-- Jamie
