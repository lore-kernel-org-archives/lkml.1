Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXKNOD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXKNOD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXKNODp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:03:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1959 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbXKNODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:03:43 -0500
Date: Wed, 14 Nov 2007 13:24:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114132448.GA5183@ucw.cz>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
> > http://bugzilla.kernel.org/show_bug.cgi?id=9275
> > Kernel: 2.6.23
> > This is HP notebook nc6320 T2400 945GM
> 
> No response from developers

Maybe I'm optimistic, but I expected Ingo/Thomas to look after nohz
problems. nohz=off highres=off fixes more than one suspend problem...

...stuff I've seen with NOHZ even without suspend (cursor blinking
irregulary) make me think that nohz perhaps should not be used in
production just yet...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
