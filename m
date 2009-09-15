Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZIOSKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZIOSKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZIOSJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:09:57 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:13570 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751772AbZIOSJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:09:56 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 14:09:56 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cleanup legacy console_print function
Date: Tue, 15 Sep 2009 11:05:43 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501F100EB@exchange.ZeugmaSystems.local>
In-Reply-To: <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cleanup legacy console_print function
Thread-Index: Aco2LoGlxTtn2kTfTw6+AaWuvqT5ZgAABksw
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0FF17@exchange.ZeugmaSystems.local> <200909151127.10697.bjorn.helgaas@hp.com> <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local> <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Tony Luck" <tony.luck@intel.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, <linux-ia64@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Umm.  Your new file "head.h" is only included by head.S ... perhaps it
>would be
>better to delete head.h entirely and drop the #include from head.S?
>

Will it resolve the function symbol though? I dunno.

I can drop the head.h completely and add:

#ifndef __ASSEMBLY__
 extern void console_print(const char *s);
#endif

to head.S if that is a better option.

  Ani

