Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZAOLrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZAOLrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZAOLrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:47:06 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2472 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZAOLrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:47:04 -0500
Date: Thu, 15 Jan 2009 12:45:21 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090115114518.GT23674@vanheusden.com>
References: <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu> <20090114214158.GA9992@elte.hu> <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com> <20090114223408.GA19173@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114223408.GA19173@elte.hu>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 15 09:10:29 CET 2009
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> > You just disproved your own case :(
> > >>
> > >> how so? 80% is not enough? I also checked Fedora and it has
> > >> SCHED_DEBUG=y in its kernel rpms.
> > >
> > > Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.

Debian too:

mauer:~/bin# grep CONFIG_SCHED_DEBUG /boot/config-2.6.2*
/boot/config-2.6.24-1-amd64:# CONFIG_SCHED_DEBUG is not set
/boot/config-2.6.25-2-amd64:CONFIG_SCHED_DEBUG=y
/boot/config-2.6.26-1-amd64:CONFIG_SCHED_DEBUG=y

> > $ zgrep DEBUG_MUTEX /proc/config.gz
> > # CONFIG_DEBUG_MUTEXES is not set

mauer:~/bin# grep DEBUG_MUTEX /boot/config-2.6.2*
/boot/config-2.6.22-3-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.24-1-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.25-2-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.26-1-amd64:# CONFIG_DEBUG_MUTEXES is not set


Folkert van Heusden

-- 
Looking for a cheap but fast webhoster with an excellent helpdesk?
http://keetweej.vanheusden.com/redir.php?id=1001
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
