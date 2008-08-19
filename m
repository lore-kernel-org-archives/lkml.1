Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbYHSW22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbYHSW22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYHSW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:28:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40171 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYHSW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:28:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 20 Aug 2008 00:27:40 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: new driver staged in linux1394-2.6.git
To: linux1394-devel@lists.sourceforge.net, v4l-dvb-maintainer@linuxtv.org
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Message-ID: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

just to keep people informed what's in the works:  There are now two new
branches in the linux1394 git repo,

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.27

This is for preparation of the firesat driver (to be renamed to firedtv
to better match the corresponding device names) for mainline submission.
I have harvested the respective patches from Greg KH's staging tree and
added two further updates; more to be added soon.

The firesat driver is for FireWire-attached external and internal DVB-C,
DVB-S, DVB-S2, and DVB-T devices from Digital Everywhere, called FireDTV
and FloppyDTV.  AFAIU some of these devices are also sold under the
EyeTV brand by Elgato.  Links to more information about firesat and the
devices can be found at
    http://ieee1394.wiki.kernel.org/index.php/Out-of-tree_Kernel_Drivers

Right now, firesat/firedtv still needs a number of cleanups.  (Luckily,
the only task to be done before mainline merge which impacts userland is
the renaming of the driver to firedtv.)  The preparations will probably
continue to go via the Linux Driver Project's mailinglist for now.  When
the essentials are done, I will post a snapshot of firedtv at LKML for
broader review.

So this is not a request to look at the current driver sources, this is
only a notice about what's going on.
-- 
Stefan Richter
-=====-==--- =--- =-=--
http://arcgraph.de/sr/

