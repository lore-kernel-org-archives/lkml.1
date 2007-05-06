Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXEFSJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXEFSJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXEFSJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:09:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37951 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbXEFSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:09:41 -0400
X-Sasl-enc: S3d21ipZCPaXfrHNP16phH0K63nFDznp5IeOUVJL5wMc 1178474981
Date: Sun, 6 May 2007 15:09:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ian <spyro@f2s.com>
Cc: Shem Multinymous <multinymous@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070506180937.GB31940@khazad-dum.debian.net>
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <1178372786.3901.4.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178372786.3901.4.camel@wirenth>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007, ian wrote:
> On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:
> 
> > Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> > control signaling over the USB bus for power-control purposes),
> 
> it might be dumb, but it is useful to know wether the PDA is charging
> from usb or mains power. and some devices allow one to switch on / off
> the ability to charge via usb

Which, at the proper abstraction level provided by this class, means that it
allows one to switch on or off a power supply channel.

Laptops let one do this with their batteries, too.  It is the same thing.  I
didn't check if the class comes with an attribute for "enable/disable this
power source", but if doesn't, we need to add one: it *is* a generic and
widely used capability in laptops, and according to you, also on PDAs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
