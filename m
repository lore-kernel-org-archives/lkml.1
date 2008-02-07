Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbYBGWYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbYBGWYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYBGWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:23:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755206AbYBGWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:23:57 -0500
Date: Thu, 7 Feb 2008 23:24:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, john.ronciak@intel.com,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [E1000-devel] e1000 1sec latency problem
Message-ID: <20080207222411.GA1917@elf.ucw.cz>
References: <20080207141718.GA2030@elf.ucw.cz> <47AB4B2E.1030801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB4B2E.1030801@intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I have the famous e1000 latency problems:
> > 
> > 64 bytes from 195.113.31.123: icmp_seq=68 ttl=56 time=351.9 ms
> > 64 bytes from 195.113.31.123: icmp_seq=69 ttl=56 time=209.2 ms
> > 64 bytes from 195.113.31.123: icmp_seq=70 ttl=56 time=1004.1 ms
> > 64 bytes from 195.113.31.123: icmp_seq=71 ttl=56 time=308.9 ms
> > 64 bytes from 195.113.31.123: icmp_seq=72 ttl=56 time=305.4 ms
> > 64 bytes from 195.113.31.123: icmp_seq=73 ttl=56 time=9.8 ms
> > 64 bytes from 195.113.31.123: icmp_seq=74 ttl=56 time=3.7 ms
> > 
> > ...and they are still there in 2.6.25-git0. I had ethernet EEPROM
> > checksum problems, which I fixed by the update, but problems are not
> > gone.
> 
> pavel, start using "e1000e" instead - this driver replaces e1000 for all the
> pci-express devices and has the infamous L1 ASPM disable patch to
> fix this issue.

Ok, e1000e seems to work for me.

In another email, you asked for lspci -vvvv of failing e1000
case. Should I still provide it?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
