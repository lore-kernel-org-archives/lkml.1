Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZBFAOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZBFAOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZBFAOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:14:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBFAOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:14:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: Re: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Date: Fri, 6 Feb 2009 01:13:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de>
In-Reply-To: <20090205232343.GA9455@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902060113.31651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Philipp Matthias Hahn wrote:
> Hello!
> 
> On Thu, Jan 29, 2009 at 10:53:40PM -0800, Yinghai Lu wrote:
> > can not find the reason why the WOL doesn't work...
> > 
> > please post
> > 1. boot log for just after AC is pluged-in... ===> you should have
> > "nv_probe: set workaround bit for reversed mac addr"
> > 2. and boot log after boot from WOL...==> you have have "nv_probe: set
> > workaround bit for reversed mac addr" too.
> 
> On Wed, Feb 04, 2009 at 11:58:53AM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12614
> > Subject		: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
> > Submitter	: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
> > Date		: 2009-01-29 6:31 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123321232825316&w=4
> > Handled-By	: Yinghai Lu <yinghai@kernel.org>
> > Patch		: http://marc.info/?l=linux-kernel&m=123330459229248&w=4
> 
> Strage, at the moment I can't seem to reproduce the problem. I've
> switched back to the version of 2.6.28.3 and now it seems to work.
> I'll continue with tesing.

OK, but for now I'll close the bug as unreproducible.

> Some additional data:
> The BIOS-upgrade tool (Afud408.exe) resets the MAC address. I had to run
> the tool a second time to re-programm the MAC-address using its /M
> option. I useed the unreversed MAC-address back than.
> I also tried the reversed address once, but after that forcedeth.c
> complained about a wrong MAC-address.
> 
> If I completely turn off the power (pull the plug), WOL doesn't work,
> even when it's enabled in the BIOS.
> 
> Only after I'v started Linux, do "echo NMAC > /proc/acpi/wakeup" and
> "ethtool -s eth0 wol g" does it work again.

The "echo NMAC > /proc/acpi/wakeup" thing shouldn't be necessary if you do
"ethtool -s eth0 wol g".

Thanks,
Rafael
