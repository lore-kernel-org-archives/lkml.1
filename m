Return-Path: <linux-kernel-owner+w=401wt.eu-S1763282AbYBZSPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763282AbYBZSPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYBZSPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:15:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34439 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYBZSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:15:44 -0500
Date: Tue, 26 Feb 2008 19:16:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226181611.GB6030@elf.ucw.cz>
References: <20080225143932.6b83b65d.akpm@linux-foundation.org> <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com> <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk> <20080226175954.GA5707@elf.ucw.cz> <20080226181001.GA7714@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226181001.GA7714@codemonkey.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 13:10:01, Dave Jones wrote:
> On Tue, Feb 26, 2008 at 06:59:54PM +0100, Pavel Machek wrote:
>  
>  > > if by 'custom' you mean the solution everyone agreed to work
>  > > toward at the power management summit several years ago
>  > > (hal/pm-utils) then, yes.
>  > 
>  > I must have been on different summit... I believe it is bad to tie
>  > s2ram to hal, because it makes testing on minimal system hard.
>  > 
>  > Anyway, what is the "default" way to trigger s2ram for Andrew? Perhaps
>  > Fedora already has his machine whitelisted...
> 
> There is no s2ram. pm-suspend uses the white/black-lists in pm-utils.
> Remember that? The cross-distro package everyone agreed was a good idea
> so that every distro didn't have their own magic utility ?

Well, we have cross-distro package, it is at suspend.sf.net , and it
can bring up video - which is kind of important. (It is single binary,
so it can be pagelocked -- which is important for s2disk).

Plus it does not depend on HAL.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
