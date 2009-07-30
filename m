Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZG3RJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZG3RJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZG3RJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:09:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62491 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZG3RJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:09:04 -0400
Date: Thu, 30 Jul 2009 13:08:58 -0400 (EDT)
From: Jonathan Reed <jdreed@MIT.EDU>
To: Pavel Machek <pavel@ucw.cz>, Geoffrey Thomas <geofft@MIT.EDU>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return ENOEXEC, not ENOENT, if a binary's or script's
 interpreter doesn't exist.
Message-ID: <alpine.DEB.2.00.0907301259170.5785@infinite-loop.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK. Current behaviour is useful -- and it is really file thats
> missing.

The current behavior is only useful to people who have an understanding of 
how interpreters and binaries work on Linux.  The average desktop user 
does not have that understanding.  The average user gets an error message
such as:

/usr/bin/foo: No such file or directory.

They then go and look at /usr/bin/foo, find that it exists, and are 
extremely confused.

More advanced users might at that point try and run "ldd" on the binary 
(which will also fail, thanks to a missing interpreter).  The average user 
will never think to run "strings" on the binary and look for 
/lib/ld-linux.so.1.

> Please improve manpage instead.

What manpage do you suggest needs improvement?  execve(2)?  That again 
requires an average user to realize that they need to go look at the 
execve(2) manpage.  The average user is not going to realize that.

-Jon

---
Jonathan Reed
jdreed@mit.edu
Faculty and Student Experience
Information Services & Technology
Massachusetts Institute of Technology
