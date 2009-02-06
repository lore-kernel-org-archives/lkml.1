Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZBFSyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZBFSyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbZBFSyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:54:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:56714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZBFSyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:54:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,392,1231142400"; 
   d="scan'208";a="428926798"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "cooloney@kernel.org" <cooloney@kernel.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       "dhowells@redhat.com" <dhowells@redhat.com>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@zankel.net" <chris@zankel.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Date: Fri, 6 Feb 2009 10:53:54 -0800
Subject: RE: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Thread-Topic: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Thread-Index: AcmIOG/TXmdHgd/MShCfOEN/PrS63AAU5frA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA36121A48B@orsmsx505.amr.corp.intel.com>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <20090206164546.6291.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com>
In-Reply-To: <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -#include <linux/types.h>
> > +#include <asm/types.h>
> >
>
> No , we do not even need asm/types.h

...

> -#include <linux/types.h>
> -

This works.

Acked-by: Tony Luck <tony.luck@intel.com>



