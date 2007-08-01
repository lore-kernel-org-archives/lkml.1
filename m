Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbXHAUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbXHAUDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbXHAUDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:03:24 -0400
Received: from zaphod.dth.net ([85.159.112.68]:41281 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbXHAUDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:03:22 -0400
Date: Wed, 1 Aug 2007 22:03:20 +0200
From: Danny ter Haar <dth@dth.net>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Update: ACPI problems: 2.6.22-git17 working, 2.6.23-rc1* is not: (was ide not working)
Message-ID: <20070801200319.GA31205@dth.net>
References: <20070727193832.GA20289@dth.net> <46AC0F6E.2000008@googlemail.com> <20070730025412.GA22888@dth.net> <200707301330.54640.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707301330.54640.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Okay

Redid git bisect from start:

git bisect log
git-bisect start
# good: [098fd16f00005f665d3baa7e682d8cb3d7c0fe6f] Linux 2.6.22
git-bisect good 098fd16f00005f665d3baa7e682d8cb3d7c0fe6f
# good: [098fd16f00005f665d3baa7e682d8cb3d7c0fe6f] Linux 2.6.22
git-bisect good 098fd16f00005f665d3baa7e682d8cb3d7c0fe6f
# bad: [7d57c74238cdf570bca20b711b2c0b31a553c1e5] Linux 2.6.23-rc1
git-bisect bad 7d57c74238cdf570bca20b711b2c0b31a553c1e5
# good: [1f1c2881f673671539b25686df463518d69c4649] Merge branch
# 'upstream-linus' of
# master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
git-bisect good 1f1c2881f673671539b25686df463518d69c4649
# good: [5b7f13bd26a0c1d394a1a1f2bb6de5130c3a3843] coda: update module
# information
git-bisect good 5b7f13bd26a0c1d394a1a1f2bb6de5130c3a3843
# good: [74889e41d9a1f80928130a02af9b010673bc5ba7] [CELL] cbe_cpufreq:
# reorganize code
git-bisect good 74889e41d9a1f80928130a02af9b010673bc5ba7
# good: [bdda1561ffda764583a295229db66d94cf6038a3] x86_64: x86_64 - Use
# non locked version for local_cmpxchg()
git-bisect good bdda1561ffda764583a295229db66d94cf6038a3
# bad: [d7f5e3df3574c6e38b99f5fe22f15540b2b9811d] Merge branch
# 'for-linus' of git://git.o-hand.com/linux-rpurdie-leds
git-bisect bad d7f5e3df3574c6e38b99f5fe22f15540b2b9811d
# bad: [08e31686d6d119ba26bf0690f5f872f6f5bd1a97] Pull thinkpad into
# release branch
git-bisect bad 08e31686d6d119ba26bf0690f5f872f6f5bd1a97
# bad: [f79e3185dd0f8650022518d7624c876d8929061b] Pull misc into release
# branch
git-bisect bad f79e3185dd0f8650022518d7624c876d8929061b
# good: [22aadf8a07067644e101267ed5003043f2ad05bf] Pull bugzilla-7880
# into release branch
git-bisect good 22aadf8a07067644e101267ed5003043f2ad05bf
# good: [e8b495fe09bc793ae26774e7b2667f7f658d56e2] Pull dock-bay into
# release branch
git-bisect good e8b495fe09bc793ae26774e7b2667f7f658d56e2
# good: [18eab8550397f1f3d4b8b2c5257c88dae25d58ed] ACPI: Enable C3 even
# when PM2_control is zero
git-bisect good 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
# good: [7a9b9068b8c7b526894904c0b9b90354825b8fbd] ACPI: update
# feature-removal-schedule.txt, /sys/firmware/acpi/namespace is gone
git-bisect good 7a9b9068b8c7b526894904c0b9b90354825b8fbd
# good: [8b8eb7d8cfc6cd95ed00cd58754e8493322505bd] ACPI: update ACPI
# proc I/F removal schedule
git-bisect good 8b8eb7d8cfc6cd95ed00cd58754e8493322505bd


f79e3185dd0f8650022518d7624c876d8929061b is first bad commit

I will store this particular firewall setup friday (will go into storage
for 2 months), if somebody would like more info, me to try something,
please send it to me asap.

Thanks for looking at this.

Danny
-- 
