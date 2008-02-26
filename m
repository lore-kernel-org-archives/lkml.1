Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbYBZRrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbYBZRrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbYBZRqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:46:54 -0500
Received: from testure.choralone.org ([194.9.77.134]:60719 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764135AbYBZRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:46:52 -0500
Date: Tue, 26 Feb 2008 12:46:13 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226174613.GA26259@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>
References: <8f53421d0802251415g2033ca6bqd4e6ea9e2d93f097@mail.gmail.com> <20080225222023.GK2659@elf.ucw.cz> <8f53421d0802251436vd98a97h5db6b8af3dc39d0@mail.gmail.com> <20080225143932.6b83b65d.akpm@linux-foundation.org> <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com> <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226101117.GA26671@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:11:17AM +0100, Pavel Machek wrote:
 > Hi!
 > 
 > Andrew is trying to get s2ram to work on Fedora:
 > 
 > > > > Please try s2ram, there's good chance it will just work.
 > > > 
 > > > configure: error: Required libx86 was not found
 > > 
 > > apt-get install libx86-dev?
 > > 
 > > Alternatively, can you post dmidecode? Thinkpads usually work with
 > > acpi_sleep=s3_bios,s3_mode ; and I can look up whitelist manually.
 > 
 > ...unfortunately, it does not ship s2ram by default, and does not even
 > carry its dependencies.
 > 
 > Is there some custom mechanism to get suspend-to-ram to work on
 > Fedora? 

if by 'custom' you mean the solution everyone agreed to work
toward at the power management summit several years ago
(hal/pm-utils) then, yes.

	Dave

-- 
http://www.codemonkey.org.uk
