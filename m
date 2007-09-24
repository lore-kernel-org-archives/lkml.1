Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXIXEOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXIXEOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 00:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXIXEOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 00:14:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42259 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXIXEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 00:14:06 -0400
Date: Sun, 23 Sep 2007 21:12:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: zippel@linux-m68k.org
Subject: xconfig request
Message-Id: <20070923211248.398cc21f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a UI request for xconfig.  Seems somewhat simple & obvious
from a user perspective.  I'm not saying that it's simple to
implement, but maybe someone out there would be interested in doing
so.


By default all menus start as open or expanded, but they can also be
closed by clicking on the "[-]" to the left of the menu heading,
to reduce the amount of screen real estate that the menu occupies.
However, when the parent menu is left (when the user moves to another
parent menu), the open/closed state of the user-requested-closed menu
is lost, so that when its parent menu is clicked/opened again, the
previously closed sub-menu is also open/expanded rather than closed.

The UI request is simply for menus that the user has requested to be
closed (unexpanded), they remain that way until the user clicks on the
"[+]" to open them.


Many examples are possible.  Here's one:

Go to the Networking menu and then cliick on "Networking options".
Click on the "[-]" to the left of "TCP/IP networking" because it takes
too much screen space.
Disable IPX and Appletalk below TCP/IP (this is just a pretend
scenario).
Now click on "Network device support".  Oops, forgot something in
the Networking menu, so click on Networking + "Networking options".
Darn, the TCP/IP networking menu is expanded again, using up all that
valuable screen space.


(maybe I just need a bigger screen :)

---
~Randy
Phaedrus says that Quality is about caring.
