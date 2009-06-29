Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZF2Rau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZF2Rau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZF2Ral
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:30:41 -0400
Received: from www17.your-server.de ([213.133.104.17]:38242 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZF2Rak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:30:40 -0400
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
From: Thomas Meyer <thomas@m3y3r.de>
To: Frans Pop <elendil@planet.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <200906180024.42998.elendil@planet.nl>
References: <Pine.LNX.4.44L0.0906161429060.5125-100000@iolanthe.rowland.org>
	 <1245275412.22520.7.camel@localhost> <200906180024.42998.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 19:30:08 +0200
Message-Id: <1246296608.21516.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.06.2009, 00:24 +0200 schrieb Frans Pop: 
> On Wednesday 17 June 2009, Thomas Meyer wrote:
> > Sure. Rearranging the usb devices and removing some hubs makes the
> > problem go away in most cases...
> 
> I see that you still have the Broadcom "Wireless RNDIS device" attached 
> that was my initial suspect after looking through your boot log.
> 
> Does removing that device make the problem go away?

No.

> Can you reproduce the problem at all without that device connected (during boot)?

yes!

> 
> Probably moving that device to a different controller than used for your 
> keyboard and mouse will also get rid of the problem. Correct?

Not tested yet.

> 
> If removing that device does solve the problem, I would guess that without 
> it you will also no longer have that "PME+" value in the output of lspci 
> for the USB Controller it is connected to.

With network device removed (during boot and later on) the PME+ doesn't
appear anymore for the USB controller.

> Hopefully someone else can then explain how/why that device forces the 
> PME+ setting for the controller.
> 
> But I must also say that to me it seems rather fragile that in default 
> configuration a random USB device can suddenly cause wakeups as result of 
> a change caused by a totally different device.
> 
> Cheers,
> FJP

