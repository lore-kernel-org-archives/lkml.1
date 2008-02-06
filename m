Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYBFL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYBFL3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYBFL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:29:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55398 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753951AbYBFL3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:29:07 -0500
Date: Wed, 6 Feb 2008 12:29:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080206112926.GB8070@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <47A90F23.80009@zytor.com> <200802060242.15097.rjw@sisk.pl> <47A9129A.7050706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A9129A.7050706@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 17:51:22, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
>>> The asm() for making beeps really need to be moved to a function and 
>>> cleaned up (redone in C using inb()/outb()) if they are to be retained at 
>>> all.
>>
>> Yes, they are.  For some people they're the only tool to debug broken resume.
>
> That's fine, but they should get cleaned up.
>
> /me is tempted to provide a version which can send messages in Morse Code ;)

Actually, it would probably be accepted. Debugging early resume is
evil enough that any help is welcome.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
