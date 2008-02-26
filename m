Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYBZKL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYBZKL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYBZKLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:11:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYBZKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:11:18 -0500
Date: Tue, 26 Feb 2008 11:11:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Jones <davej@codemonkey.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226101117.GA26671@atrey.karlin.mff.cuni.cz>
References: <20080225215049.GD2659@elf.ucw.cz> <8f53421d0802251415g2033ca6bqd4e6ea9e2d93f097@mail.gmail.com> <20080225222023.GK2659@elf.ucw.cz> <8f53421d0802251436vd98a97h5db6b8af3dc39d0@mail.gmail.com> <20080225143932.6b83b65d.akpm@linux-foundation.org> <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com> <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226000007.GB22102@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Andrew is trying to get s2ram to work on Fedora:

> > > Please try s2ram, there's good chance it will just work.
> > 
> > configure: error: Required libx86 was not found
> 
> apt-get install libx86-dev?
> 
> Alternatively, can you post dmidecode? Thinkpads usually work with
> acpi_sleep=s3_bios,s3_mode ; and I can look up whitelist manually.

...unfortunately, it does not ship s2ram by default, and does not even
carry its dependencies.

Is there some custom mechanism to get suspend-to-ram to work on
Fedora? If not, would it be possible to start shipping s2ram from
suspend.sf.net? 

(Unlike s2disk, this will not eat filesystems, I promise  :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
