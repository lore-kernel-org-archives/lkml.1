Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZHSQEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZHSQEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZHSQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38121 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845AbZHSQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:02 -0400
Date: Wed, 19 Aug 2009 17:05:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
In-Reply-To: <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
	<20090818151427.GA6295@kroah.com>
	<ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 09:41:56 -0600
"Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu> wrote:

> Greg KH wrote:
> > On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
> > What are you using the binary sysfs attribute for?  It should ONLY be
> > used as a pass-through to and from hardware, with no interpretation by
> > the kernel at all.
> 
> It's for the Logitech G13's game panel image (a simple binary bitmap of
> the pixels).
> 
> It doesn't do any interpretation... just a few checks on the magic number
> and size.

If its a bitmap image why not register the device as a framebuffer ?
