Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXIETDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXIETDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXIETC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:02:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46804 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbXIETCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:02:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46DEFD08.8060402@s5r6.in-berlin.de>
Date: Wed, 05 Sep 2007 21:01:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: debian-powerpc@lists.debian.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Teulings <rael@edge.ping.de>, michal.k.k.piotrowski@gmail.com,
       rbrito@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsber?= =?ISO-8859-1?Q?g?= 
	<krh@redhat.com>
Subject: firewire in prebuilt kernel packages (was Re: Sleep problems with
 kernels >= 2.6.21 on powerpc)
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>	<6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>	<20070827065246.GA21220@ime.usp.br>	<46D279E8.10001@edge.ping.de>	<46D72BC6.3020809@edge.ping.de> <20070905100754.57ab4e3e.akpm@linux-foundation.org> <46DEEBBE.4070201@s5r6.in-berlin.de>
In-Reply-To: <46DEEBBE.4070201@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30 Aug 2007 22:42:46 +0200 "Tim Teulings" <rael@edge.ping.de> wrote:
>>> The kernel is:
>>>> Linux kismet 2.6.22-1-powerpc #1 Sun Jul 29 13:58:06 CEST 2007 ppc GNU/Linux
>>> The relveant debian package:
>>>> linux-image-2.6.22-1-powerpc_2.6.22-3_powerpc.deb
>>> I'm running a mixture of debian testing/unstable.

At the moment, distributors should not provide the experimental
firewire-* drivers as the only or primary FireWire drivers, unless they
know exactly what the gotchas are.  As a hint, CONFIG_FIREWIRE currently
depends on EXPERIMENTAL, CONFIG_IEEE1394 does not.  Some basic
information can be found at http://wiki.linux1394.org/JujuMigration.
-- 
Stefan Richter
-=====-=-=== =--= --=-=
http://arcgraph.de/sr/
