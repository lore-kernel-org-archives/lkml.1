Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXKNT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXKNT6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXKNT57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:57:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45575 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbXKNT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:57:58 -0500
Date: Wed, 14 Nov 2007 19:52:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, Natalie Protasevich <protasnb@gmail.com>,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114195208.GD23221@flint.arm.linux.org.uk>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Natalie Protasevich <protasnb@gmail.com>, linux-ide@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	linux-input@atrey.karlin.mff.cuni.cz
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071114132448.GA5183@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114132448.GA5183@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 01:24:48PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9275
> > > Kernel: 2.6.23
> > > This is HP notebook nc6320 T2400 945GM
> > 
> > No response from developers
> 
> Maybe I'm optimistic, but I expected Ingo/Thomas to look after nohz
> problems. nohz=off highres=off fixes more than one suspend problem...
> 
> ...stuff I've seen with NOHZ even without suspend (cursor blinking
> irregulary) make me think that nohz perhaps should not be used in
> production just yet...

It appears that bug 9229 has been solved, and the reporter of that
bug now says that:

  If I unset NO_TZ suspend/resume works.
  If I set it suspend/resume doesn't works.

So I think this guy is now suffering from bug #9275

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
