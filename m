Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758869AbYLPX0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYLPX0P (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYLPXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:25:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:8848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbYLPXZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:25:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,233,1228118400"; 
   d="scan'208";a="415056647"
From: "Luck, Tony" <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mathieu.desnoyers@polymtl.ca" <mathieu.desnoyers@polymtl.ca>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Date: Tue, 16 Dec 2008 15:25:40 -0800
Subject: RE: local_add_return
Thread-Topic: local_add_return
Thread-Index: Aclfzv7Y2ehGL4/iQ+KK6iTJwM8/RgABhZyw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C91870C@orsmsx505.amr.corp.intel.com>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
 <200812161703.00697.rusty@rustcorp.com.au>
 <20081215.231314.92267481.davem@davemloft.net>
 <200812170908.05423.rusty@rustcorp.com.au>
In-Reply-To: <200812170908.05423.rusty@rustcorp.com.au>
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

> Any chance of an IA64 or s390 run?  You can normalize if you like, since
> it's only to compare the different approaches.

-EDOESNOTCOMPILE

  CC      init/main.o
init/main.c: In function 'test_local_variants':
init/main.c:756: error: 'atomic_long_t' has no member named 'a'
make[1]: *** [init/main.o] Error 1

-Tony
