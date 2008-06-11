Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYFKLGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYFKLGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYFKLFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:05:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1891 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754616AbYFKLFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:05:36 -0400
Date: Wed, 11 Jun 2008 12:33:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, devzero@web.de
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080611103330.GA5612@ucw.cz>
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br> <20080602192012.GA7748@ucw.cz> <4846744A.9040204@diamondcut.com.br> <484D10DE.30704@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484D10DE.30704@diamondcut.com.br>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-09 08:15:42, Renato S. Yamane wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Renato S. Yamane wrote:
> > Pavel Machek wrote:
> >> Renato S. Yamane wrote:
> >>> Pavel Machek wrote:
> >>>> (And yes, your hw is broken; on pc it is traditionaly hw
> >>>> responsibility to power machine down.)
> >>> OK, I try do this but I think this is very difficult because demand
> >>> power is very low and is not enought to do hot some component. But I
> >>> will try.
> >>>
> >>> I don't think that my hardware is broked because I don't have this kind
> >>> of problem on Kernel <=2.6.22 or in other OS.
> >>> Track: <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> >> Can you try to find out when that started happening?
> >> does it still happen with acpi=off?
> >> does it each too much power if you use 4second hold of power button to
> >> shut it down from running linux?
> > 
> > With acpi=off this problem don't happening, but a lot of other problem
> > happening (as fan control).
> > 
> > I will try halt my laptop holding power button today and report you
> > tomorrow.
> 
> If I hold power button to force shutdown I don't have this problem with
> battery charge.

Too bad, I can't call the hw terminally broken, then.

If you boot into init=/bin/bash (minimum drivers) will it still
consume too much power after sysrq-o?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
