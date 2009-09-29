Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZI2WzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZI2WzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZI2WzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:55:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46006 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbZI2WzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:55:18 -0400
Date: Tue, 29 Sep 2009 23:52:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090929145514.GF2152@localhost>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
> interrupt context with low_latency set and that is obviously incorrect,
> right?

It seems to do it from a work queue - or did I miss a case ?
