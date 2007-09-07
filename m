Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbXIGLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbXIGLxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXIGLxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:53:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3227 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965205AbXIGLxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:53:45 -0400
Date: Fri, 7 Sep 2007 11:53:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFD] new syscalls: suspend_other/resume_other?
Message-ID: <20070907115333.GA3901@ucw.cz>
References: <200709021704.22325.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709021704.22325.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-09-02 17:04:21, Ingo Oeser wrote:
> Hi there,
> 
> at the moment implementing a mark and sweep garbage collection 
> subsystem is quite a hack, because you always have to use up
> some signals for suspend/resume all threads to implement this.
> 
> For runtime environments (like D system libraries or JVMs) this is 
> a hack, since you take away flexibility from the application.
> 
> A possible solution would be a syscall or a PTRACE extension
> to realize the suspend/resume. I best describe the possible
> syscall manpages here, so you get an idea.
> 
> NAME 
> 	suspend_other - suspends execution of all but the calling thread

aha, this should really be named stop_other / cont_other, suspend is
already taken :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
