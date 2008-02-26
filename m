Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbYBZR7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbYBZR7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762189AbYBZR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:59:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34222 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761756AbYBZR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:59:29 -0500
Date: Tue, 26 Feb 2008 18:59:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226175954.GA5707@elf.ucw.cz>
References: <20080225222023.GK2659@elf.ucw.cz> <8f53421d0802251436vd98a97h5db6b8af3dc39d0@mail.gmail.com> <20080225143932.6b83b65d.akpm@linux-foundation.org> <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com> <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226174613.GA26259@codemonkey.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 12:46:13, Dave Jones wrote:
> On Tue, Feb 26, 2008 at 11:11:17AM +0100, Pavel Machek wrote:
>  > Hi!
>  > 
>  > Andrew is trying to get s2ram to work on Fedora:
>  > 
>  > > > > Please try s2ram, there's good chance it will just work.
>  > > > 
>  > > > configure: error: Required libx86 was not found
>  > > 
>  > > apt-get install libx86-dev?
>  > > 
>  > > Alternatively, can you post dmidecode? Thinkpads usually work with
>  > > acpi_sleep=s3_bios,s3_mode ; and I can look up whitelist manually.
>  > 
>  > ...unfortunately, it does not ship s2ram by default, and does not even
>  > carry its dependencies.
>  > 
>  > Is there some custom mechanism to get suspend-to-ram to work on
>  > Fedora? 
> 
> if by 'custom' you mean the solution everyone agreed to work
> toward at the power management summit several years ago
> (hal/pm-utils) then, yes.

I must have been on different summit... I believe it is bad to tie
s2ram to hal, because it makes testing on minimal system hard.

Anyway, what is the "default" way to trigger s2ram for Andrew? Perhaps
Fedora already has his machine whitelisted...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
