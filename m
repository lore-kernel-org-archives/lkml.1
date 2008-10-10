Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYJJUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYJJUvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763444AbYJJUvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:51:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45817 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762629AbYJJUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:51:08 -0400
Date: Fri, 10 Oct 2008 21:50:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Stefan Bader <stefan.bader@canonical.com>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
 used_vectors bitmap
Message-ID: <20081010215038.13be501e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081010204133.GB32357@kroah.com>
References: <48EFB4B2.2020508@canonical.com>
	<20081010201805.GC32164@kroah.com>
	<48EFBCA4.6020008@zytor.com>
	<20081010204133.GB32357@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 13:41:33 -0700
Greg KH <greg@kroah.com> wrote:

> On Fri, Oct 10, 2008 at 01:35:48PM -0700, H. Peter Anvin wrote:
> > Greg KH wrote:
> >> Is there a problem with being assigned to IRQ0 in situations like this?
> >
> > On PCs, IRQ 0 is dedicated to use for the PIT.
> 
> Ah, I didn't realize it couldn't be shared.

And more importantly dev->irq == 0 or IRQ == 0 to anything but arch
internal code means "no interrupt line".
