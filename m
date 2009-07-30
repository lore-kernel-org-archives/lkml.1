Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZG3URZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZG3URZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZG3URY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:17:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60744 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZG3URY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:17:24 -0400
Date: Thu, 30 Jul 2009 22:17:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonathan Reed <jdreed@MIT.EDU>
Cc: Geoffrey Thomas <geofft@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return ENOEXEC, not ENOENT, if a binary's or script's
	interpreter doesn't exist.
Message-ID: <20090730201720.GA30001@elf.ucw.cz>
References: <alpine.DEB.2.00.0907301259170.5785@infinite-loop.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907301259170.5785@infinite-loop.mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-30 13:08:58, Jonathan Reed wrote:
>> NAK. Current behaviour is useful -- and it is really file thats
>> missing.
>
> The current behavior is only useful to people who have an understanding 
> of how interpreters and binaries work on Linux.  The average desktop
> user 

Proposed behaviour is useless to everyone.

> does not have that understanding.  The average user gets an error message
> such as:
>
> /usr/bin/foo: No such file or directory.
>
> They then go and look at /usr/bin/foo, find that it exists, and are  
> extremely confused.

ENOEXEC is confusing, too. It will have x bit.

>> Please improve manpage instead.
>
> What manpage do you suggest needs improvement?  execve(2)?  That
>again  

execve, I'd say.

> requires an average user to realize that they need to go look at the  
> execve(2) manpage.  The average user is not going to realize that.

Improve shells to provide more helpful error message?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
