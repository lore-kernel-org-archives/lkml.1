Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZGTXot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZGTXot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZGTXoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:44:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46194 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbZGTXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:44:46 -0400
Date: Tue, 21 Jul 2009 00:45:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721004531.1036d9af@lxorguk.ukuu.org.uk>
In-Reply-To: <20090720215841.GJ19257@buzzloop.caiaq.de>
References: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk>
	<1248112313-7842-1-git-send-email-daniel@caiaq.de>
	<20090720234829.1b32b2c0@t61.ukuu.org.uk>
	<20090720215841.GJ19257@buzzloop.caiaq.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Depends on how you define the time of removal. The user space connection
> stays open after the device was removed. 

If that is occuring then the bug is elsewhere. The hang up sequence
reconnects the user space to the hung up tty ops and no longer references
the hardware.

