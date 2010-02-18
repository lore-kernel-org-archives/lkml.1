Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0BRTAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:00:19 -0500
Received: from void.printf.net ([89.145.121.20]:34105 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab0BRTAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:00:12 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 14:00:11 EST
From: Chris Ball <cjb@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
References: <20100218095200.63509b8c@bike.lwn.net>
Date: Thu, 18 Feb 2010 13:49:13 -0500
In-Reply-To: <20100218095200.63509b8c@bike.lwn.net> (Jonathan Corbet's message
	of "Thu, 18 Feb 2010 09:52:00 -0700")
Message-ID: <m37hqamlau.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   > The ChangeLog file under drivers/char is 30K of stuff dedicated
   > to the mid-90's TTY exploits of Ted Ts'o; it has been updated
   > once since 1998 - and that was in 2001.  It's interesting
   > history, but we don't normally carry that kind of history inline
   > with the code.  Let's remove it.

Should we lose the others too, then?

pullcord:cjb~/git/linux-2.6 % du -sh **/ChangeLog
8.0K	arch/arm/nwfpe/ChangeLog
32K	drivers/char/ChangeLog
20K	drivers/parport/ChangeLog
16K	fs/befs/ChangeLog
100K	fs/ntfs/ChangeLog

Last changed dates:

arch/arm/nwfpe/ChangeLog  = 2003/03
drivers/parport/ChangeLog = 2001/10
fs/befs/ChangeLog         = 2002/03
fs/ntfs/ChangeLog         = 2007/10

The ntfs changelog is modified recently, but the ChangeLog text added
to it is duplicated as the commit message for each change, so those
ChangeLog entries are redundant -- they're already in the commit
history, unless you want changes from earlier than the initial import
cutoff in 2004, in which case you'd need the history repo for those.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
