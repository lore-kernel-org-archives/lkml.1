Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZDFJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZDFJO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZDFJOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:14:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51725 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754684AbZDFJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:13:59 -0400
Date: Mon, 6 Apr 2009 10:14:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: USB: serial: add symbol serial driver
Message-ID: <20090406101401.4be69c01@lxorguk.ukuu.org.uk>
In-Reply-To: <20090406053753.GA12019@kroah.com>
References: <200903261929.n2QJTS5L009700@hera.kernel.org>
	<20090326194228.52087a47@lxorguk.ukuu.org.uk>
	<20090406053753.GA12019@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The above is bogus cargo cult programming copied from old drivers and
> > should be removed.
> 
> It's all over the usb-serial drivers, should I just remove it from all
> of them?

I think so yes. USB folks used it to avoid overrunning the old flip
buffer system and with proper buffering that isn't needed. Now its only
relevance is if you need very low latency responses which is normally an
application layer choice.

Alan
