Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXBJSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXBJSAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXBJSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:00:32 -0500
Received: from mailgate.cesmail.net ([216.154.195.36]:43396 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751399AbXBJSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:00:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 13:00:31 EST
Message-ID: <20070210125351.05uo0o0sgw0w0ckc@webmail.spamcop.net>
Date: Sat, 10 Feb 2007 12:53:51 -0500
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Theodore Tso <tytso@mit.edu>, James Ketrenos <jketreno@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel
	PRO/Wireless 3945ABG
References: <45CCE3CA.4050904@linux.intel.com>
	<20070210162254.GC25607@thunk.org> <20070210163933.GA17140@tuxdriver.com>
In-Reply-To: <20070210163933.GA17140@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) 4.0-cvs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "John W. Linville" <linville@tuxdriver.com>:

> > Very cool!  Is it likely that d80211 and iwlwifi will be pushed into
> > mainline in time for 2.6.21?
>
> Hmmm...I think we need to spend a cycle or so in -mm.  2.6.22 seems
> more likely for mainline.

I think we should take this as a goal.  Last time I checked, d80211 wasn't in
-mm.  Perhaps it should go there.  And by the way, the latest changes from
netdev->class_dev to netdev->dev break d80211.  Perhaps we should rebase
wireless-dev immediately after 2.6.21-rc1, fix all compile issues and submit
the patch to -mm.

And iwlwifi is surprisingly good for a just announced driver.  It worked for me
from the first attempt, and that's the first d80211 driver to do so.  In my
opinion, it should go to wireless-dev as soon as possible so it can go to -mm
toghether with other drivers.  A couple of wrinkles in the standalone build
system are irrelevant to the kernel interation.

--
Regards,
Pavel Roskin
