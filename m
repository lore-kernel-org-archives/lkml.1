Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZGJXll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZGJXll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZGJXla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:41:30 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:39004 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbZGJXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:41:29 -0400
Date: Sat, 11 Jul 2009 00:09:26 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
       Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.31] rfkill: allow toggling soft state in sysfs again
Message-ID: <507E529B48%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1247262952.26071.1.camel@johannes.local>
References: <4A5716AA.5000903@ph.tum.de> 
 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com> 
 <4A5743AB.6090303@ph.tum.de> 
 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com> 
 <4A575119.9070505@ph.tum.de> <507E3B9268%linux@youmustbejoking.demon.co.uk> 
 <1247254899.21972.9.camel@johannes.local> 
 <507E47A184%linux@youmustbejoking.demon.co.uk> 
 <1247262952.26071.1.camel@johannes.local>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>, John Linville 
 <linville@tuxdriver.com>, Thiemo Nagel <thiemo.nagel@ph.tum.de>, Corentin Chary 
 <corentin.chary@gmail.com>, debian-eeepc-devel@lists.alioth.debian.org, 
 acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org, 
 linux-kernel@vger.kernel.org
User-Agent: Messenger-Pro/2.58.5.3087 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Sat, 8988 Dec 1984 00:09:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Johannes Berg may or may not have written...

> On Fri, 2009-07-10 at 22:09 +0100, Darren Salt wrote:
>> I demand that Johannes Berg may or may not have written...
[snip]
>>> *shrug*, I don't like it, but whatever...
>> I do. It means that we have a nice simple text-based interface for use in
>> scripts (for now), and a binary interface which is better suited to the
>> likes of desktop applications.

> Indeed, and as long as you expect to only use soft toggle... problem is
> that you won't know whether it's soft-toggled or not while it's
> hard-blocked (off)!

Which is fine for eeepc-acpi-scripts and anything else which doesn't care
about hard-blocking because the hardware doesn't do that.

eeepc-acpi-scripts should eventually use your rfkill utility, though. (I
intend to make sure that it does so.)

[snip]
-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
|   Kill all extremists!

A large dog will have a surprising effect on your life.
