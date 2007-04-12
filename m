Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXDLT6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXDLT6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030354AbXDLT6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:58:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4131 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965583AbXDLT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:58:44 -0400
Date: Thu, 12 Apr 2007 13:50:29 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 00/41] AppArmor security module overview
Message-ID: <20070412135028.GE5881@ucw.cz>
References: <20070412090809.917795000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412090809.917795000@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> AppArmor's Overall Design
> =========================
> 
> AppArmor protects systems from vulnerable software by confining
> processes, giving them "least privilege" access to the system's
> resources: with least privilege, processes are allowed exactly what they
> need, nothing more, and nothing less. Systems are thus protected from
> bugs in applications that would lead to privilege escalation, such as
> remote system access because of a buffer overflow in a web server, etc.
> 
> AppArmor does this by defining application profiles which list allowed
> accesses, and assigning those profiles to processes. AppArmor does *not*

You can do the same with ptrace. If that's not fast enough... improve
ptrace?

> The corollary to this is that attacks against AppArmor that start with
> "assume some unconfined process does ..." are outside the AppArmor
> threat model. Any process that might do something malicious to an

IOW AppArmor is broken by design. (One reason is: operations by unconfined
processes that did not use to be security sensitive before -- ln
shadow random_name -- are security sensitive now.)

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
