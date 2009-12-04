Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZLDXoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZLDXoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbZLDXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:44:53 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:32819 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZLDXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:44:53 -0500
Date: Fri, 4 Dec 2009 15:44:59 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Lior Dotan <liodot@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Message-ID: <20091204234459.GC25713@hexapodia.org>
References: <4B151FE2.3090807@gmail.com> <20091203182336.GA21309@hexapodia.org> <20091204202433.GB21309@hexapodia.org> <a5bf86a80912041339g3d35cbfcrd56669f746d095ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5bf86a80912041339g3d35cbfcrd56669f746d095ff@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-adding LKML.

On Fri, Dec 04, 2009 at 11:39:25PM +0200, Lior Dotan wrote:
> On Fri, Dec 4, 2009 at 10:24 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> > For what it's worth, I'm testing suspend-to-ram on Ubuntu 9.10 x86_64
> > with 2.6.32 final on a T500 and it's been pretty reliable -- I've
> > suspended by closing the lid at least a dozen times and it hasn't locked
> > up yet.
> 
> I'm using either KDE menu to suspend or hibernate-ram from hibernate-script.
> I will try to use the lid and see if it makes any difference.
> The strange thing is that I tried using rc6 & rc7 and they don't work now
> even though they used to, so I now I need to see what broke it.

I mentioned the lid because of BZ #14484 which is only on Intel GMA plus
using the lid switch to trigger suspend.  Since neither is relevant to
you it's just a red herring. :)

> > 1. are you using DMAR (VT-d)?  I'm not, and I had problems on another
> >   machine (also Core 2 Duo with GM45 graphics) when I tried suspending
> >   with CONFIG_DMAR=y.
>
>  I disabled DMAR but still no luck.

It's getting better but DMAR has still been a little problematic for me
the last few months.  Updating to the very latest BIOS does help
sometimes.

> > 2. are you running into http://bugzilla.kernel.org/show_bug.cgi?id=14484
> >   or a similar problem?
> > 3. (if you have GMA graphics) Are you up to date on the xorg-video-intel
> >   driver?  I'm using KMS and xorg-video-intel 2.9.0.  2.8.x is missing
> >   some relevant bugfixes.  (Of course if you have ATI graphics then
> >   this isn't relevant.)
> >
> I'm using the Radeon GPU so no KMS for me yet.

Sounds like your Radeon or fglrx driver got updated and broke
suspend/resume.

-andy
