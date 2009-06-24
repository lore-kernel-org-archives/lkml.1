Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZFXRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZFXRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZFXRUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:20:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:45325 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZFXRUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:20:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,284,1243839600"; 
   d="scan'208";a="469232222"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "kyle@mcmartin.ca" <kyle@mcmartin.ca>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Jesper.Nilsson@axis.com" <Jesper.Nilsson@axis.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Chris Zankel <chris@zankel.net>
Date: Wed, 24 Jun 2009 10:20:17 -0700
Subject: RE: [PATCH 02/10] linker script: throw away .discard section
Thread-Topic: [PATCH 02/10] linker script: throw away .discard section
Thread-Index: Acn0l68fhOGLzkIER0m/EZ7N42+NUgAWAjcw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A8C95D49@orsmsx505.amr.corp.intel.com>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
 <1245825924-30412-3-git-send-email-tj@kernel.org>
In-Reply-To: <1245825924-30412-3-git-send-email-tj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> x86 throws away .discard section but no other archs do.  Also,
> .discard is not thrown away while linking modules.  Make every arch
> and module linking throw it away.  This will be used to define dummy
> variables for percpu declarations and definitions.

Seems harmless on ia64.  Kernel still builds, boots and loads
modules.

Tested-by: Tony Luck <tony.luck@intel.com>

-Tony
