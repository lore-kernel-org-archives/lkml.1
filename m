Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZJLBzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZJLBzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZJLBzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:55:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57383 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752017AbZJLBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:55:01 -0400
Date: Sun, 11 Oct 2009 21:54:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ben Efros <ben@pc-doctor.com>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
In-Reply-To: <1255294292.2192.40.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910112150020.638-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Benjamin Herrenschmidt wrote:

> Don't those devices support SANE_SENSE fine on LUN 0 according to
> Alan parsing of my traces ?

Not really; the device returned only the usual 18 bytes of sense data.  
But at least it did so correctly instead of failing.

>  Heh, they may even work if I actually
> populate the SD-CARD slot, I'll try later.

Possibly, but I sure wouldn't bet on it.   :-)

> I still think it's simpler and potentially more future-proof to just
> have a back-off scenario.
> 
> Now, whether we ping pong the US_FL_SANE_SENSE flag or not is minor,
> I tend to think that your approach that doesn't touch the flag might
> indeed be better.
> 
> I'll test the patch later today.

And of course there remains the question of why the serial driver
wasn't loaded and probed.  Would it make a difference if that driver
was already loaded when you plugged in the modem?

Alan Stern

