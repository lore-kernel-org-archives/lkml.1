Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYFDLww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYFDLww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYFDLwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:52:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40995 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbYFDLwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:52:44 -0400
Date: Wed, 4 Jun 2008 12:36:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, wim@iguana.be,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: AT91SAM9/CAP9 watchdog driver
Message-ID: <20080604123642.51449a04@core>
In-Reply-To: <cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	<20080603142316.c53b32b2.akpm@linux-foundation.org>
	<cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 09:31:50 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> hi Andrew,
> 
> >> +             return 0;
> >
> > That looks like the wrong return value?
> 
> Since the watchdog registers are Write-Once, if the user does not
> specify a "wdt_timeout" parameter we'd still like the driver to load
> even if it's not enabled.

Surely you can avoid doing the register writes until after you check the
validity of arguments ?
