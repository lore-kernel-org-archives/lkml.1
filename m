Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZIOSLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZIOSLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIOSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:11:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:47722 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZIOSLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:11:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,391,1249282800"; 
   d="scan'208";a="493711754"
From: "Luck, Tony" <tony.luck@intel.com>
To: Anirban Sinha <ASinha@zeugmasystems.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Tue, 15 Sep 2009 11:11:03 -0700
Subject: RE: [PATCH] cleanup legacy console_print function
Thread-Topic: [PATCH] cleanup legacy console_print function
Thread-Index: Aco2LoGlxTtn2kTfTw6+AaWuvqT5ZgAABkswAAA3iUA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E05DBC6E@orsmsx505.amr.corp.intel.com>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0FF17@exchange.ZeugmaSystems.local>
 <200909151127.10697.bjorn.helgaas@hp.com>
 <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local>
 <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com>
 <DDFD17CC94A9BD49A82147DDF7D545C501F100EB@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F100EB@exchange.ZeugmaSystems.local>
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

> Will it resolve the function symbol though? I dunno.
>
> I can drop the head.h completely and add:
>
> #ifndef __ASSEMBLY__
> extern void console_print(const char *s);
> #endif
>
> to head.S if that is a better option.

head.S is in assembler (hence the ".S" suffix).  So adding
code wrapped inside #ifndef __ASSEMBLY__ to it would be a
no-op.

On ia64 (and I think most other assemblers) it is not
necessary to provide any kind of "extern" declaration
before using external symbols.

-Tony
