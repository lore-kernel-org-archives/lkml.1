Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYKJOQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYKJOQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:16:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYKJOPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:15:53 -0500
Received: from hope.ime.usp.br ([143.107.45.8]:43770 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753915AbYKJOPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:15:52 -0500
Date: Mon, 10 Nov 2008 12:15:50 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       acpi-bugzilla@lists.sourceforge.net, rui.zhang@intel.com
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Message-ID: <20081110141550.GB4450@ime.usp.br>
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br> <20081109113332.GD6094@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081109113332.GD6094@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel.

On Nov 09 2008, Pavel Machek wrote:
> On Sun 2008-11-09 00:45:14, Rogério Brito wrote:
> > On Nov 08 2008, Justin Mattock wrote:
> > > On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> > > > I think that I have some more information regarding the
> > > > suspend/hibernate issue: with Ubuntu's 2.6.27 kernel, I can't
> > > > hibernate my laptop, but with vanilla 2.6.28-rc3, I can hibernate
> > > > (I have not tested it much, but it seems to work).

I spoke too soon. Depending on what I do in userland (I tried using the
GNOME application "Cheese" just to put some load on the machine) and I
tried:

# echo shutdown > /sys/power/disk
# echo disk > /sys/power/state

But the machine stuck: it blanked the monitor, seemed to go to a console,
the cursor was blinking on the upper left corner of the screen, the HD
light blinked once and then the fan went faster, the CPU hotter and the
leds corresponding to caps lock and scroll lock were blinking.

I'm waiting with the machine in this situation since I started composing
this e-mail and nothing has changed.

The blinking leds (caps and scroll lock) would indicate a kernel panic, is
that correct?

> Try it from the text console, and see what exactly stops
> responding. "killall klogd" is your friend.

The funny thing is that once that I could resume, it resumed
instantly. :-( Weird.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
