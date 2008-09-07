Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYIGMw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYIGMw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 08:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYIGMwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 08:52:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36524 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYIGMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 08:52:16 -0400
Date: Sun, 7 Sep 2008 14:53:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pageexec@freemail.hu,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080907125331.GA1707@elf.ucw.cz>
References: <20080903195122.73905236@infradead.org> <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu> <1220609647.4879.169.camel@pasglop> <48C10EC5.24400.3008276@pageexec.freemail.hu> <1220612231.4879.175.camel@pasglop> <20080905114233.GA27878@elte.hu> <20080905204134.GI19337@1wt.eu> <20080906154551.GB1774@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906154551.GB1774@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-09-06 17:45:51, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Then they will simply proceed like this :
> >   - patch /boot/vmlinuz
> >   - sync
> >   - crash system
> > 
> > => user says "oh crap" and presses the reset button. Patched kernel boots.
> >    Game over. Patching vmlinuz for known targetted distros is even easier
> >    because the attacker just has to embed binary changes for the most
> >    common distro kernels.
> 
> a reboot often raises attention. But yes, in terms of end user boxes, 
> probably not. Anyway, my points were about transparent rootkits 
> installed on a running system without anyone noticing - obviously if the 
> attacker can modify the kernel image and the user does not mind a reboot 
> it's game over.

Well, install a rootkit in /boot/vmlinuz, sync, then wait for user to
reboot its system?

Even well-kept servers are rebooted from time to time.

I agree -- the only way to win is not to play this game.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
