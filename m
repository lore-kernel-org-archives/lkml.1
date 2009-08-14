Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZHNNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZHNNwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbZHNNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:52:18 -0400
Received: from gvgeloven01.mjopr.nl ([212.83.231.34]:59525 "EHLO mjopr.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbZHNNwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:52:17 -0400
Message-ID: <4A856C45.40706@users.sourceforge.net>
Date: Fri, 14 Aug 2009 15:53:09 +0200
From: Pander <pander@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] charger: Offer kernel build that disables disks, screen,
 etc. and lets laptop serve as charger for USB/FireWire devices
References: <4A855F5D.1010502@users.sourceforge.net>
In-Reply-To: <4A855F5D.1010502@users.sourceforge.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pander wrote:
> Hi all,
> 
...
> 
> This can be achieved by building a special kernel that will shut down
> all hardware that is not needed for offering power on the before
> mentioned ports. Perhaps this can be achieved by kernel configuration
> alone or it might require a minimal of functionality to put a laptop
> into such a charging state.

Alternative implementation could be that this functionality is present
in a normal kernel and is only activated by boot time command argument
'charger'.

While being on the subject anyway, optionally, extra functionality could
be implemented for turning the laptop into an emergency light. The boot
time command argument 'light' could offer this.

The same functionality as with charger will be enabled and the screen
and keyboard will powered up. Initially, the screen will be white. By
means of the following keys: arrow op, arrow down, arrow left, arrow
right, page up, page down, home, end, return, tab one is able to change
the color of the screen in on of 16 basic colors: white, yellow,
fuchsia, red, silver, gray, olive, purple, maroon, aqua, lime, teal,
green, blue, navy and black (perhaps omit the latter). The space bar key
would enable and disable the screen but still allow for the other keys
to change the color. Also the brightness keys should be supported.

Of course this is easily done by software on a fully booted system.
However, due to the emergency situation, again power can be scarce and
must be used as efficient as possible. Considering and discussing
implementation of this greatly overlaps the aforementioned proposal.

Kind regards,

Pander
