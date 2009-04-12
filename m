Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDLSWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDLSWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZDLSWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:22:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1805 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZDLSWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:22:07 -0400
Subject: Re: [PATCH] balance parentheses and braces
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <20090412122419.GA27929@uranus.ravnborg.org>
References: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
	 <20090412122419.GA27929@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 11:21:33 -0700
Message-Id: <1239560493.14004.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-12 at 14:24 +0200, Sam Ravnborg wrote:
> I suggest you put some effort into finding the relevant receivers for these patches.
> This way they are more likely to be picked up and applied.

Or using the MAINTAINER patches and script I sent
and very little effort:

Without recent git-signers:

$ ./scripts/get_maintainer.pl -f --no-git arch/blackfin/mach-bf538/include/mach/cdefBF538.h
uclinux-dist-devel@blackfin.uclinux.org
Bryan Wu <cooloney@kernel.org>
$ ./scripts/get_maintainer.pl -f --no-git arch/blackfin/mach-bf548/include/mach/anomaly.h
uclinux-dist-devel@blackfin.uclinux.org
Bryan Wu <cooloney@kernel.org>
$ ./scripts/get_maintainer.pl -f --no-git drivers/atm/iphase.c
netdev@vger.kernel.org
Chas Williams <chas@cmf.nrl.navy.mil>
$ ./scripts/get_maintainer.pl -f --no-git drivers/media/dvb/frontends/stv0900_priv.h
linux-media@vger.kernel.org
Mauro Carvalho Chehab <mchehab@infradead.org>
$ ./scripts/get_maintainer.pl -f --no-git drivers/video/sis/init301.c
Thomas Winischhofer <thomas@winischhofer.net>

or with recent git-signers:

$ ./scripts/get_maintainer.pl -f arch/blackfin/mach-bf538/include/mach/cdefBF538.h
uclinux-dist-devel@blackfin.uclinux.org
Bryan Wu <cooloney@kernel.org>
Mike Frysinger <vapier.adi@gmail.com>
Yi Li <yi.li@analog.com>
Michael Hennerich <michael.hennerich@analog.com>
$ ./scripts/get_maintainer.pl -f arch/blackfin/mach-bf548/include/mach/anomaly.h
uclinux-dist-devel@blackfin.uclinux.org
Bryan Wu <cooloney@kernel.org>
Mike Frysinger <vapier.adi@gmail.com>
Robin Getz <rgetz@blackfin.uclinux.org>
$ ./scripts/get_maintainer.pl -f drivers/atm/iphase.c
netdev@vger.kernel.org
Chas Williams <chas@cmf.nrl.navy.mil>
David S. Miller <davem@davemloft.net>
"Jorge Boncompte [DTI2]" <jorge@dti2.net>
Andrew Morton <akpm@linux-foundation.org>
Wu Fengguang <fengguang.wu@intel.com>
$ ./scripts/get_maintainer.pl -f drivers/media/dvb/frontends/stv0900_priv.h
linux-media@vger.kernel.org
Mauro Carvalho Chehab <mchehab@infradead.org>
Mauro Carvalho Chehab <mchehab@redhat.com>
Randy Dunlap <randy.dunlap@oracle.com>
Igor M. Liplianin <liplianin@netup.ru>
Andrew Morton <akpm@linux-foundation.org>
$ ./scripts/get_maintainer.pl -f drivers/video/sis/init301.c
Thomas Winischhofer <thomas@winischhofer.net>


