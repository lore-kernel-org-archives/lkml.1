Return-Path: <linux-kernel-owner+w=401wt.eu-S935541AbYD1UYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541AbYD1UYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbYD1UYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:24:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:47274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbYD1UYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:24:35 -0400
Date: Mon, 28 Apr 2008 20:24:33 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4 usage statistics
Message-ID: <20080428202433.GA13417@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would be very interested in getting feedback about kernel 2.4 usage.
Please, please, I do not want this thread to degenerate into a useless
flamewar or "mine is bigger" discussion. For this reason, I would like
that participants reply privately to me so that this mail does not turn
into a thread.

I know 2.4 is still used in a lot of sensible areas, although far less
than 2.6 nowadays. At least I know that several appliance makers/sellers
still use it in new products, and even very old versions sometimes. What
I'd like to estimate is the way it is used, if it is systematically
patched with local add-ons, frequency of updates (if any), etc... so
that I can adapt my process if needed. For instance, I don't release
any -rc for stable releases because I'm convinced that nobody will ever
test them, but I have no problem being proved wrong.

If I get enough replies to build up a statistic synthesis, I'll try to
summarise it (eventhough 73% of statistics are all made up :-) ).

This "poll" is not meant to dictate what will get merged next (we're in
feature freeze anyway), but it helps me know your usage better, to try
to serve you better. Also, if a majority of people report the same
problem or lacking feature for which a trivial fix is know, it can be
studied.

Basically what I'd like to know is the following. You can use the proposed
responses as a guide, but they're not mandatory. Also if possible and adapted,
please report number of concerned units :

1) where do you use it ?
   - PC turned into network equipment (router, LB, BGP route reflector, ...)
   - security equipment (firewall, vpn, ids/ips, traffic analyzer, ...)
   - proxy services (proxy, smtp relay, reverse-proxy, anti-virus/spam, ...)
   - storage/directory server (NFS, LDAP, logging, ...)
   - multi-function server (proxy/fw/nfs/mail/...)
   - monitoring / remote access
   - desktop/workstation
   - laptop (if recent, what model ?)
   - dedicated appliances (that you may be designing/selling)
   - soho embedded systems (eg: wifi routers, ...)
   - PDA ?
   - other ?

2) how critical are the systems it runs on ?
   - medical (people's health depend on them) ?
   - finance (massive amounts of money pass through them) ?
   - business-critical (you may go bankrupt if it fails too often) ?
   - mission-critical (you may loose your job if it fails too often) ?
   - security-critical (security gets degraded when it fails) ?
   - users get angry at you when it fails (admin, or do this for a living) ?
   - not that important (you may reboot when you decide to do so) ?
   - no importance at all (eg: home usage, experimentation, ...) ?

3) how many users are you serving with it approximately, all systems
   included ? Or better, how many people will notice the failure at once
   if any ? Note: do not count web population as users, but use maximum
   concurrent users instead.
   - < 10
   - < 100
   - < 1000
   - < 10000
   - more ?

4) what version are you running ?
   - latest or close to that (eg: 2.4.36.x)
   - latest was available last time you upgraded
   - somewhat old mainline (2.4.32-2.4.34)
   - quite old mainline (2.4.21..2.4.31)
   - very old mainline (2.4.2, 2.4.17, ...)
   - debian's 2.4.27
   - rhel 3's 2.4.21
   - my other standard distros's 2.4 kernel
   - an embedded distro's heavily patched 2.4 (port to other archs, ...)

5) have you applied any patches ?
   - provided with the distro
   - security: pax/grsec/ow, capabilities, ...
   - performance: epoll, variable_hz, jiffies_64, preempt, O(1), ...
   - network: tcp md5, transparent proxy, netfilter tcp_window_tracking...
   - drivers: very specific to your platform, self-added PCI-IDs, vendors'
   - filesystems: updated jffs2+mtd, squashfs, cifs, fuse, ...
   - security/stability fixes backported from later 2.4 versions
   - other security/stability fixes or improvements
   - drivers backported from 2.6
   - other ?

6) how often do you update (may translate into avg uptime) ?
   - every release
   - every major release after a few dot-versions
   - only when you see an important (to you) security fix
   - same as well as with reliability fixes
   - at least once a year
   - only if you need to re-install
   - after a lot of careful revalidation
   - never

7) how do you test ?
   - pre-production environment in equivalent conditions
   - long-term reliability stress-tests (days to weeks)
   - quick regression testing before production
   - you test in production
   - no test at all, blind upgrade
   - other ?

8) why have you not upgraded to 2.6 yet (including Adrian's 2.6.16.X ?)
   - not needed, all features OK and hardware still 100% compatible
   - you have to change user-space tools
   - you don't feel comfortable with 2.6's patch pace (but 2.6.16 is quite
     comparable to 2.4)
   - you do not trust 2.6 enough yet ? (why ?)
   - missing features you had in 2.4 mainline that are not in 2.6 anymore ?
   - missing features you had in your 2.4 patches that do not exist in 2.6 ?
   - drivers not existing anymore in 2.6 ?
   - drivers not working anymore in 2.6 ?
   - performance regression in 2.6 ?
   - you find 2.6 more complicated ?
   - other ?

9) when do you plan to switch to 2.6 ?
   - it has already begun (and as a supplement, if you had to do so because
     2.4 did not work anymore for you for other reasons than hardware
     support and features, please indicate which ones)
   - very soon (<1 year)
   - not before 1 year
   - next installations
   - next batch of major upgrades
   - when your hardware is not compatible anymore
   - when you can't build 2.4 with your distro's gcc
   - when 2.6 supports feature/driver XXX
   - when 2.6 is more reliable (example ?)
   - when 2.6 development slows down
   - the latest possible (why ???)
   - never (why ??? and what would you switch to then ?)

10) any comments or suggestions about current release process, minor issues
    that you are facing each time such as external patches that do not apply,
    recurrent problems on all of your setups, etc... ?


Well, that's all. You do not need to respond precisely, and once again,
I'm just trying to get the figure.

And please do not forget! Reply to me directly, do not pollute the list,
that way you will refrain the random geeks from comparing their setups
to other ones.

Thanks!
Willy

