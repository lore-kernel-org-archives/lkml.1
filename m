Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZASTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZASTRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZASTR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:17:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42895 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZASTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:17:28 -0500
Date: Mon, 19 Jan 2009 20:17:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: MartinG <gronslet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but
	fails in later versions
Message-ID: <20090119191720.GB6463@ucw.cz>
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com> <20090116085326.GC4795@atrey.karlin.mff.cuni.cz> <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 23:43:08, MartinG wrote:
> On Fri, Jan 16, 2009 at 9:53 AM, Pavel Machek <pavel@suse.cz> wrote:
> > Can you boot non-working kernel, and try "cd /sys/devices/system/cpu;
> > echo 0 > cpu1/online; echo 1 > cpu1/online" ?
> >
> > If it breaks, try just doing "echo 0 > online" followed by s2ram. That
> > should work.
> 
> Ok, thanks for the reply. This is what I've tried (I have a single
> core (old) cpu):
> # uname -r
> 2.6.29-0.35.rc1.git4.fc11.i686
> # cd /sys/devices/system/cpu
> # find .|grep online
> ./online
> # cat online
> 0
> # echo 0 > online; echo 1 > online
> -bash: online: Permission denied
> -bash: online: Permission denied
> # chmod +rw online
> # echo 0 > online; echo 1 > online
> -bash: echo: write error: Input/output error
> -bash: echo: write error: Input/output error
> 
> Yep, I am a bit confused - any hints appreciated!

Ok, that is not going to work on single core. Can you try if
suspending works in init=/bin/bash mode?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
