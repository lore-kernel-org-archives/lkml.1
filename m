Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYLOVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYLOVNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYLOVNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:13:04 -0500
Received: from wm56.inbox.com ([64.135.83.56]:1564 "HELO WM56.inbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755689AbYLOVNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:13:02 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 16:13:01 EST
Mime-Version: 1.0
Date: Mon, 15 Dec 2008 13:03:28 -0800
Message-ID: <CCCA86B6E10.000005AEeuphoria@inbox.com>
From: euphoria@inbox.com
Subject: losing a menuconfig session to a typo
To: linux-kernel@vger.kernel.org
X-Mailer: INBOX.COM
X-Originating-IP: 169.139.26.98
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-IWM-ACU: PLUtcUJobOPyyuW56TwQMhoCelcXThhKPzeyaCbNI2vYlZcH_1MQaDZKMspc
  AosNU6pyADpwqDfZKn1oHRP1uKOQy_Ala9WW-AIZ6TMN5m08ouBnbpM964Rr
  gQehHZMuRAT7wyqxr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easy to accidentally lose a menuconfig session.  Scenarios start with a
user being accustomed to hitting [right-arrow][return] to exit from a typical
menu.  Perhaps the user prefers his underutilized numeric keypad over adding to
the beating [escape] takes.  Scenarios finish with the user accidentally
issuing [right-arrow][return] to "Do you wish to save? <Yes> <No>".  I only
lost a quick change, but it's easy to imagine how a few hours of menuconfig
time might go away.  "It'll just take a few minutes to whip my distro's kernel
into shape."  Yeah right.  Four hours of guesswork and research later, you're
tired, thinking about the make command to follow, [right-arrow][return] as
usual, wait! no! damndamndamn!, yer snookered.

There are a variety of simple ways to address this.  First, change the menu.
Swapping the order of the <Yes> and <No> would be begging for even more
trouble.  However, the <Yes>/<No> decision could be made a <Yes>/<Maybe>/<No>
decision.  This leaves <Yes>, the predominant choice, in place.  <Maybe>, in
the disputed position, could simply present the same menu.  Someone might even
have a little well-deserved fun with <Maybe> menus.  This doesn't seem all that
intrusive to me.  Second, print the diff.  When changes aren't saved, a diff of
the original config and one that would've been saved could simply be written to
stdout followed by a little blurb, "Those were the changes you didn't save.".
Third, add a save command.  I save at comfortable intervals when editing
everything else, why not kernel configurations?  This reduces the scope of
lossage in general.

Regards, [Ag]   Andy Gaynor   euphoria@inbox.com
