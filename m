Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZE3IZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZE3IZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZE3IZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:25:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41349 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751333AbZE3IZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:25:26 -0400
Date: Sat, 30 May 2009 09:25:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Subject: Re: [PATCH] 8250: Fix oops from setserial
Message-ID: <20090530092557.57578dd5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090529205429.c9c73b19.akpm@linux-foundation.org>
References: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
	<20090529205429.c9c73b19.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >  static void set_io_from_upio(struct uart_port *p)
> >  {
> > +	struct uart_8250_port *up = (struct uart_8250_port *)p;
> 
> container_of() is nicer, IMO.  It's clearer, and doesn't require that
> the uart_port be the fist member.

See the rest of the driver - it was written that way years ago and this
is just following the existing design.
