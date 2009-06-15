Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZFORch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZFORch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZFORca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:32:30 -0400
Received: from www17.your-server.de ([213.133.104.17]:42494 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZFORca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:32:30 -0400
Subject: Re: How to unset CONFIG_SERIO_I8042 on x86?
From: Thomas Meyer <thomas@m3y3r.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <4A366E67.4040300@oracle.com>
References: <1244915236.3288.7.camel@localhost.localdomain>
	 <4A366E67.4040300@oracle.com>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 19:32:29 +0200
Message-Id: <1245087149.6821.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 15.06.2009, 08:53 -0700 schrieb Randy Dunlap:
> Thomas Meyer wrote:
> > Is it possible? Does it make sense?
> 
> Enabled CONFIG_EMBEDDED, then disable KEYBOARD_ATKBD and
> disable MOUSE_PS2, then you can disable SERIO_I8042.

Thanks. Works. I missed to unset the AT keyboard.

> 
> 
> Is the Macbook all USB for input devices?

Mine is.

And in general also, I guess.

> 
> 
> > I always get this message at boot up on my macbook pro:
> > 
> > [    0.929828] PNP: No PS/2 controller found. Probing ports directly.
> > [    0.930761] i8042.c: No controller found.
> > [    0.931038] mice: PS/2 mouse device common for all mice
> > 
> > Or please make these messages warnings only, so I don't see them with
> > kernel option quiet.
> 
> 

