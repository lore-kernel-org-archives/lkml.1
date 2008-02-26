Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbYBZSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbYBZSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYBZSKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:10:15 -0500
Received: from testure.choralone.org ([194.9.77.134]:35610 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYBZSKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:10:13 -0500
Date: Tue, 26 Feb 2008 13:10:01 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226181001.GA7714@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>
References: <8f53421d0802251436vd98a97h5db6b8af3dc39d0@mail.gmail.com> <20080225143932.6b83b65d.akpm@linux-foundation.org> <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com> <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk> <20080226175954.GA5707@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226175954.GA5707@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 06:59:54PM +0100, Pavel Machek wrote:
 
 > > if by 'custom' you mean the solution everyone agreed to work
 > > toward at the power management summit several years ago
 > > (hal/pm-utils) then, yes.
 > 
 > I must have been on different summit... I believe it is bad to tie
 > s2ram to hal, because it makes testing on minimal system hard.
 > 
 > Anyway, what is the "default" way to trigger s2ram for Andrew? Perhaps
 > Fedora already has his machine whitelisted...

There is no s2ram. pm-suspend uses the white/black-lists in pm-utils.
Remember that? The cross-distro package everyone agreed was a good idea
so that every distro didn't have their own magic utility ?

sigh, I give up.

	Dave

-- 
http://www.codemonkey.org.uk
