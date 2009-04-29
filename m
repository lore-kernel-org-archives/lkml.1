Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbZD2NR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbZD2NR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbZD2NK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:10:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37127 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939AbZD2NKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:10:54 -0400
Date: Wed, 29 Apr 2009 15:13:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
Message-ID: <20090429131356.GB4047@elf.ucw.cz>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp> <20090408133524.395437925@I-love.SAKURA.ne.jp> <20090410171001.GA26156@elf.ucw.cz> <200904130204.n3D24JNk095583@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904130204.n3D24JNk095583@www262.sakura.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-04-13 11:04:19, Tetsuo Handa wrote:
> Hello.
> 
> Pavel Machek wrote:
> > Could we get an user<->kernel interface documentation?
> 
> It is at http://tomoyo.sourceforge.jp/en/2.2.x/policy-reference.html
.

Ouch:

2.5 Memory Allocation Rules

In TOMOYO Linux, memory allocated for holding access permissions and
words are never freed. There is no way except rebooting the system
that can free unneeded memory.

But don't worry. The policy seldom changes after you start production
mode. By tuning policy before starting production mode, you can reduce
memory usage to (usually) less than 1 MB.

....does that mean that it leaks memory by design?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
