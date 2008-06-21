Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbYFUNXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbYFUNXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 09:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYFUNXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 09:23:39 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35929 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFUNXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 09:23:38 -0400
Subject: Re: [PATCH 00/70] tty updates proposed for 2.6.27
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20080621090910.GA12516@kroah.com>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
	 <20080621090910.GA12516@kroah.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 15:23:44 +0200
Message-Id: <1214054624.25820.68.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > This patch series introduces the idea of a tty_port - a common structure
> > that eventually all ports will have. Some drivers are migrated to make partial
> > use of the tty port commonality and helpers but only a little.
> > 
> > On the USB side the USB tty API is changed to fix a whole pile of races where
> > tty->port->tty cannot be assumed to be tty (because of hangup/reopen). The
> > USB drivers all get a spring clean and the entire pile have been dragged into
> > CodingStyle near compliance (some cases where the checkpatch whines that
> > make no sense have been ignored).
> > 
> > Greg: At the end of this series there shouldn't be any white space issues
> > although some earlier patches introduce them and later ones take them away
> 
> Ah, thanks for resending these, as they are primarily USB changes, any
> objection for me to take these through my USB tree?

for everything that Alan touches in the Bluetooth drivers, you have an
ack from me. I am happy if this goes in quickly and I only have to
re-base my tree once.

Regards

Marcel


