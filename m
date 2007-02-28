Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbXB1OdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbXB1OdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXB1OdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:33:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54226 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932791AbXB1OdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:33:23 -0500
Date: Wed, 28 Feb 2007 15:37:02 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Christopher Meller <cmeller@innominate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question on tty line discipline
Message-ID: <20070228153702.0e172fa1@lxorguk.ukuu.org.uk>
In-Reply-To: <20070228134711.GA8631@innominate.com>
References: <20070228134711.GA8631@innominate.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 14:47:12 +0100
Christopher Meller <cmeller@innominate.com> wrote:

> Hi,
> 
> I have a question concerning the line discipline behaviour for serial
> devices.
> When the line discipline is set via ioctl from  user space to e.g. N_PPP and the userspace program returns without resetting  the line discipline back to N_TTY, the serial device cannot be used (ENODV) until an appropriate  ioctl (to N_TTY) is performed. Is there any reason for the fact that the line discipline is not reset by the kernel , when closing the device. 

No special reason, it has simply always been that way. Getty and friends
are expected to put the tty back into a sane state.
