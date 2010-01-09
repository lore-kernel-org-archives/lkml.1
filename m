Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891Ab0AINkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0AINkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410Ab0AINkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:40:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0AINkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:40:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 9 Jan 2010 14:40:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Bart?omiej Zimo?" <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001022201.04281.rjw@sisk.pl> <20100109103212.GA1429@ucw.cz>
In-Reply-To: <20100109103212.GA1429@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001091440.46434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010, Pavel Machek wrote:
> > > Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> > > Usually programs needs just to disconnect something or set one flag.
> > > Even if program will have no time for this it could be enough just to send this precious info.
> > 
> > Perhaps I don't understand correctly what you're trying to achieve, but at the
> > moment suspend is always started from user space, this way or another, and on
> 
> At least zaurus (arm) suspends from kernel on battery critical.

I wasn't aware of this.

That may be a good reason for adding kernel-based suspend notification,
although I'd prefer ARM to notify the user space about the critical battery
status allowing it to decide what to do.

IMhO automatic suspend without something like the Android's wakelocks hurts
more than it helps.

Rafael
