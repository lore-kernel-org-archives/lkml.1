Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZALWOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZALWOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZALWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:14:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:21928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbZALWOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WZ/ihPf+yMroXUhazBhIopGCYfu3nIzOczK1o8nMw4CRBzmsMlu1/FvO6C4WE7NqrQ
         C9GhKOVZWp8lI0faJgyiQFwYzJrtjRXNOzd8/vhizAVAwwECRaDVSnQD1us62rvBpWG2
         BxEmjWzA7dPnRjvhXrWbogwgd+sKByM6vdxOc=
Date: Tue, 13 Jan 2009 01:14:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Can we get warnings from the x86 userspace headers fixed?
Message-ID: <20090112221412.GG13384@localhost>
References: <20090112212855.GB15185@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112212855.GB15185@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Mon, Jan 12, 2009 at 10:28:55PM +0100]
| Hi Ingo.
| 
| We have recently introduced a lot of new warnings for our
| userspace headers.
| 
| Try to do a "make headers_check" and enjoy...
| 
| Are there any chance you could ask one of your helpers to
| start to look into the x86 specific ones?
| 
| If we get x86 clean this would create more incentive to
| make the generic clean too.
| 
| I had originally planned to attack the generic headers
| (include/linux/*) but I'm faced by reality after my
| vacation and has almost no spare time for the time being.
| 
| I already fixed the sparc headers but that is not 
| visible compared to x86 (the fixes was btw easy).
| 
| I can try to help by doing a few reviews in the
| beginning but I need to fix kbuild stuff first where
| I have a few serious issues pending. And lacks time...
| 
| 	Sam
| 

Sam, I hope to find some spare time for this
tomorrow (it's night here). At least in one
moment headers_check assume that CONFIG is exported
into user space even being bound by pure C comments.

---
/home/cyrill/projects/kernel/linux-2.6.git/usr/include/asm/e820.h:13: leaks
CONFIG_NODES to userspace where it is not valid
---

Just a note.

		- Cyrill -
