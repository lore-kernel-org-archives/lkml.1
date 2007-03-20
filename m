Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXCTRCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXCTRCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXCTRCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:02:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965491AbXCTRCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:02:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Date: Tue, 20 Mar 2007 18:05:57 +0100
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <20070320123245.GA19019@elf.ucw.cz>
In-Reply-To: <20070320123245.GA19019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703201805.58299.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 13:32, Pavel Machek wrote:
> Hi!
> 
> ...and cause is really simple.
> 
> During resume, we do not know that "reboot" method was used, so we
> assume plaform and make the led blink...
> 
> Unfortunately I see no easy solution, and this may/will cause other
> problems -- in case of broken bios and user telling us not to call
> that bios, we'll call it anyway.
> 
> (Ouch and I think this is regression after 2.6.20?)

I'm not sure, will check that later.

The solution would be to pass the information about the suspend mode used
in the image header, I think (that's what uswsusp does after my recent patch).

Greetings,
Rafael
