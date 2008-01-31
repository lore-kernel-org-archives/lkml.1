Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbYAaW1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbYAaW1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYAaW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:27:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:55215 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYAaW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Mlg1DHunVwAq7SrgPawx7rur7uzjEasWKhNCh2FJIHtRz5hFVlnlDX3hEloAMkBGTE2lsMhDlZKBcBd0vvHs7ag/exr0Jbvo9pQ+8bLkzIRYeKNqEzP1fzqUxVG2X8Sg17zDNZ5t7zl/EvBwvmeMa1NRRKP7oSzI+xZTjfgAEU8=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Thu, 31 Jan 2008 22:26:57 +0000
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200801220603.02986.chris2553@googlemail.com> <200801312013.31220.chris2553@googlemail.com> <20080131210338.GK6413@tuxdriver.com>
In-Reply-To: <20080131210338.GK6413@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801312226.57972.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008, John W. Linville wrote:
> On Thu, Jan 31, 2008 at 08:13:31PM +0000, Chris Clayton wrote:
> > Hi John,
> > 
> > On Wednesday 23 January 2008, John W. Linville wrote:
> > > On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > > > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > > > Hi again.
> > > > > 
> > > > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > > > Hi,
> > > > 
> > > > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > > > (the none I sent earlier was from -git4, by the way)
> > > > 
> > > > Call Trace:
> > > > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > > > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > > > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > > > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> > > 
> > > I suspect this could relate to this commit:
> > > 
> > > commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> > > Author: Mattias Nissler <mattias.nissler@gmx.de>
> > > Date:   Mon Nov 12 15:03:12 2007 +0100
> > > 
> > >     rt2x00: Allow rt61 to catch up after a missing tx report
> > > 
> > > Could you revert that patch, rebuild, and try to recreate the problem?
> > 
> > As you will have seen, Matthias doubted whether his patch would be at the root
> > of the problem I am seeing. I noticed you posted some patches earlier this week.
> > Would any combination of those be likely to fix the bug, please? The patch
> > http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream/0001-rt61pci-fix-up-merge-damage.patch
> > applies cleanly to 2.6.24 but the build fails :(
> 
> This patch is not intended for 2.6.24, so that won't help. :-)
> 
> I saw Mattias's reply, but I didn't see him suggest any other
> fixes... :-(  I'm wondering if maybe you tried reverting it anyway?
> I only ask because the call trace references symbols that would seem
> to relate to the patch.  So even if _why_ it might break things isn't
> obvious, it still might be worth trying a revert "just in case". :-)
> 

Yes, I did revert Matthias' patch- see http://marc.info/?l=linux-wireless&m=120116461507261&w=4
which is what Matthias was replying to.

> > It seems that it may take a little while to get to the bottom of this bug. Should
> > I raise an incident on bugzilla?
> 
> I've seen other reports of rt61 working fine with 2.6.24.  So I
> suppose you should open a bug.
> 

OK, I'll do that. 

Incidentally, I've seen other posting to the linux-wireless list containing discussion
about problems when using an 11g device to connect to an 11b AP. That's exactly
what I am doing with a Belkin F5D7010 wireless adapter and a Draytek Vigor
2600WE AP. 

> Thanks!
> 
> John

-- 
Beauty is in the eye of the beerholder.
