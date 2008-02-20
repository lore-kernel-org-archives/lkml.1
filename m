Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYBTBkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYBTBkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYBTBkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:40:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51358
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbYBTBkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:40:08 -0500
Date: Tue, 19 Feb 2008 17:40:44 -0800 (PST)
Message-Id: <20080219.174044.193702420.davem@davemloft.net>
To: david-b@pacbell.net
Cc: andre@tomt.net, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB OOPS 2.6.25-rc2-git1
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802191619.55207.david-b@pacbell.net>
References: <47BAF36C.4000509@tomt.net>
	<20080219.142401.152827357.davem@davemloft.net>
	<200802191619.55207.david-b@pacbell.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Tue, 19 Feb 2008 16:19:54 -0800

> On Tuesday 19 February 2008, David Miller wrote:
> > From: Andre Tomt <andre@tomt.net>
> > Date: Tue, 19 Feb 2008 16:19:08 +0100
> > 
> > > Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
> > > not doing anything interesting at the time, but has its / and kernel on 
> > > a usb-storage device (usb pen drive).
> > > 
> > > Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
> > > post .config and some additional info when I get home later if it isn't 
> > > obvious what broke.
> > 
> > FWIW, I've seen a near identical crash on my Niagara system.
> 
> Please try that diagnostic patch I sent ... with CONFIG_USB_DEBUG.

I have that patch applied with USB_DEBUG enabled, I'll let you know
if it triggers.

It doesn't happen often, say once in every 20 or so boots.
