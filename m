Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXBKXxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXBKXxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXBKXxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:53:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbXBKXxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:53:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:50:23 +0100
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702120041.22608.rjw@sisk.pl> <1171237646.4493.148.camel@nigel.suspend2.net>
In-Reply-To: <1171237646.4493.148.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120050.24539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 00:47, Nigel Cunningham wrote:
> Hi.
> 
> On Mon, 2007-02-12 at 00:41 +0100, Rafael J. Wysocki wrote:
> > > I'm using M$ hibernation and Suspend2 to dual boot on our desktop (dtv
> > > card that Linux doesn't support well yet), and I know other Suspend2
> > > users doing the same. It's made earier by the fact that Suspend2 lets
> > > you reboot instead of powering down.
> > 
> > Well, I don't know why you're saying it's a special capability of suspend2.
> > Even the "old" swsusp has been able to do this since I can remember. ;-)
> 
> It does?! I just did cat /sys/power/disk and it only says platform. How
> do you make swsusp reboot instead of powering down?

echo reboot > /sys/power/disk && echo disk > /sys/power/state

Greetings,
Rafael
