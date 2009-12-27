Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZL0IjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZL0IjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 03:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZL0IjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 03:39:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60541 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZL0IjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 03:39:17 -0500
Date: Sun, 27 Dec 2009 09:38:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: michael@laptop.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, andi@firstfloor.org,
       david@lang.hm, socketcan@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       herbert@gondor.apana.org.au, Valdis.Kletnieks@vt.edu, bdonlan@gmail.com,
       zbr@ioremap.net, cscott@cscott.net, jmorris@namei.org,
       ebiederm@xmission.com, bernie@codewiz.org, mrs@mythic-beasts.com,
       randy.dunlap@oracle.com, xiyou.wangcong@gmail.com, sam@synack.fr,
       casey@schaufler-ca.com, serue@us.ibm.com
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227083857.GC11737@elf.ucw.cz>
References: <20091227010441.GA12077@heat>
 <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-27 17:36:48, Tetsuo Handa wrote:
> Michael Stone wrote:
> > Further suggestions?
> 
> I expect that the future figure of this "disablenetwork" functionality becomes
> "disablesyscall" functionality.
> 
> What about defining two types of masks, one is applied throughout the rest of
> the task_struct's lifetime (inheritable mask), the other is cleared when
> execve() succeeds (local mask)?
> 
> When an application is sure that "I know I don't need to call execve()" or
> "I know execve()d programs need not to call ...()" or "I want execve()d
> programs not to call ...()", the application sets inheritable mask.
> When an application is not sure about what syscalls the execve()d programs
> will call but is sure that "I know I don't need to call ...()", the application
> sets local mask.

Syscalls are very wrong granularity for security system. But easy to
implement, see seccomp.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
