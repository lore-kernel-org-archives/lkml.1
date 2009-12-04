Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZLDUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZLDUYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZLDUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:24:28 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:37460 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbZLDUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:24:27 -0500
Date: Fri, 4 Dec 2009 12:24:33 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Lior Dotan <liodot@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Message-ID: <20091204202433.GB21309@hexapodia.org>
References: <4B151FE2.3090807@gmail.com> <20091203182336.GA21309@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203182336.GA21309@hexapodia.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:23:36AM -0800, Andy Isaacson wrote:
> On Tue, Dec 01, 2009 at 03:53:38PM +0200, Lior Dotan wrote:
> > Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
> > second time. Suspending for the first time works ok but when I resume and
> > later try to suspend again the screen gets blank and the moon LED blinks
> > forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.
> 
> How are you suspending -- pm-suspend, gnome power manager, closing the
> lid, ... ?

For what it's worth, I'm testing suspend-to-ram on Ubuntu 9.10 x86_64
with 2.6.32 final on a T500 and it's been pretty reliable -- I've
suspended by closing the lid at least a dozen times and it hasn't locked
up yet.

Things to check:

1. are you using DMAR (VT-d)?  I'm not, and I had problems on another
   machine (also Core 2 Duo with GM45 graphics) when I tried suspending
   with CONFIG_DMAR=y.
2. are you running into http://bugzilla.kernel.org/show_bug.cgi?id=14484
   or a similar problem?
3. (if you have GMA graphics) Are you up to date on the xorg-video-intel
   driver?  I'm using KMS and xorg-video-intel 2.9.0.  2.8.x is missing
   some relevant bugfixes.  (Of course if you have ATI graphics then
   this isn't relevant.)

-andy
