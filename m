Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0BLTBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:01:25 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:52060 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568Ab0BLTBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:01:23 -0500
Message-ID: <4B75A5CF.70308@lougher.demon.co.uk>
Date: Fri, 12 Feb 2010 19:02:39 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare>
In-Reply-To: <20100212150137.648dca7c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:

> There are 3881 entries in that directory today,
> and it keeps growing!
> 
> 
> I can think of several ways to improve the situation here, some of
> which could be combined.
> 
> 1* Keep a single compression format. This saves almost 40% of the
> files.
> 
> 2* Move one of the compression formats somewhere else, so that it
> doesn't get in the way but is still available if needed.
> 
> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
> related files there. This would shrink the main index drastically, and
> each subdirectory would have a reasonable size (except maybe 2.6.16 and
> 2.6.27.) Oddly enough this has been done for the files under testing/
> already, so I am curious why we don't do it for the release files (and
> the testing/incr/ files, while we're at it.)
> 
> 4* Get rid of the LATEST-IS-* files. This is a small count, won't save
> much, but these files seem totally useless to me these days. Depending
> on what you want exactly, there are many versions which can be
> considered the latest, and there are better ways to know which they are
> (for example http://www.eu.kernel.org/kdist/finger_banner ). And these
> files tend to get stuck so you can't rely on them anyway.
> 

5* Archive all the older 2.6.x files and move them into a separate
    directory (e.g. v2.6-pre20).  Moving all the pre 2.6.20 files
    saves 42% of the file listing.

This seems an obvious solution, what am I missing?

Thanks

Phillip

