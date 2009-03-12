Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZCLVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZCLVjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZCLVjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:39:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45832 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752269AbZCLVjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:39:03 -0400
Date: Thu, 12 Mar 2009 21:38:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Armbruster <armbru@redhat.com>, Anders Kaseorg <andersk@MIT.EDU>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [PATCH] IRQ handling race and spurious IIR read
 in serial/8250.c
Message-ID: <20090312213831.5045f5d0@lxorguk.ukuu.org.uk>
In-Reply-To: <18873.25299.416627.13221@mariner.uk.xensource.com>
References: <874oxyei9k.fsf@pike.pond.sub.org>
	<20090312180955.1f52a401@lxorguk.ukuu.org.uk>
	<18873.25299.416627.13221@mariner.uk.xensource.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  1. It is definitely correct and does not introduce any new bugs.

Right ;)

>  2. It makes the existing bug definitely go away.  That is, after my
>     patch is applied the code drives the UART correctly - that is,
>     according to the specification and in a manner guaranteed to be

The UART hardware and specifications diverge - often quite spectacularly.

>  4. Any fix which does not involve completely removing UART_BUG_TXEN
>     will need my change.   

Or the locking fix

It was described as a band aid so I treated it as such. Regardless of the
right thing to do long term its not a 2.6.29 candidate at this point but
certainly something that wants looking into in 2.6.30
