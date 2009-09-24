Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZIXTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZIXTU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZIXTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:20:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34902 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752946AbZIXTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:20:27 -0400
Date: Thu, 24 Sep 2009 20:21:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Johan Hovold <jhovold@gmail.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
In-Reply-To: <200909242103.48562.oliver@neukum.org>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 21:03:47 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag, 24. September 2009 17:40:23 schrieb Johan Hovold:
> > Is there a reason why this was not fixed in ftdi_sio (and whiteheat?)
> > along with the other drivers?
> 
> No good reason. They escaped my grep pattern. Mea culpa.

ftdi_sio is correct with low_latency set as it uses a work queue to
process the packets received.

Alan
