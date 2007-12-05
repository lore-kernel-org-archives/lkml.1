Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbXLEAHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbXLEAHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLEAHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:07:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLEAHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:07:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: Suspend order
Date: Wed, 5 Dec 2007 01:26:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-main <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20071204213132.d806a24f.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071204213132.d806a24f.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712050126.13123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 4 of December 2007, Kristoffer Ericson wrote:
> Hey rafael,
> 
> For obvious reasons it would be great to have serial output to be the last to enter suspend, thus giving every last drop of debugging
> before actually turning the machine "off".
> 
> I'm not aware of any specific order currently, from what I've seen currently  every driver is asked to go into suspend at the same time. This of course providing driver x isn't dependant on driver y. You following?
> 
> So, without digging to much into this, is there any specific order?

Yes, there is.

Devices are suspended in the order reverse with respect to the one in which
they have been registered (ie. the last registered device is suspended first).

Still, if you want the serial console to work over the suspend, try booting the
kernel with the no_console_suspend command line switch (that's applicable to
the current mainline, there was a configuration option for that previously).

Greetings,
Rafael
