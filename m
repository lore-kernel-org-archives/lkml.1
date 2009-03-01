Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbZCAWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbZCAWn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZCAWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:43:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55155 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbZCAWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:43:19 -0500
Date: Sun, 1 Mar 2009 23:45:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org,
       takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
Message-ID: <20090301224549.GC1961@elf.ucw.cz>
References: <49A2521E.5030805@nttdata.co.jp> <20090225194615.GE2645@elf.ucw.cz> <20090227100350.1515.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227100350.1515.A69D9226@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes. maybe ioctl() is worse, but I don't think c-like language parser
> > in kernel is acceptable.
> 
> for just clarification to me.
> 
> IIUC, many developers said UNNECESSARY parser is BAD (yes, I also think so),
> but nobody said any parser is bad.
> 
> Therefore, I think point is that the patch have enough reasonable reason or not.
> and, I thought "pavel, good job. you're right" at you oppositing time because
> tomoyo did't explain any reason at that time.
> 
> However, they changed. the patch description of the "[TOMOYO #15 3/8] Common functions for TOMOYO Linux."
> explain the reason.
> for me, I feel it's reasonable reason. then I didn't oppose current tomoyo posting.
> 
> So, I don't understand which you oppose
>    (1) ANY parser is bad.
>    (2) current description still don't explain enough reason.
> 
> May I ask you?

I'm not sure if I've seen all the TOMOYO patches... But from what I've
seen of TOMOYO design, putting the parser into kernel was "just
because"; it did not have any good reason. I hate to say that, but
AppArmor was better designed there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
