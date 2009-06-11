Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZFKGau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZFKGau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZFKGal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:30:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:58597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZFKGak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,200,1243839600"; 
   d="scan'208";a="465376751"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Thu, 11 Jun 2009 07:30:36 +0100
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
Thread-Topic: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
Thread-Index: AcnqJGIMtgTLI2TFTiyZBZdeBAxNLAAOGZbw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
In-Reply-To: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5B6VX54015120

>-----Original Message-----
>From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Thursday, June 11, 2009 1:37 AM
>To: linux-tip-commits@vger.kernel.org
>Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T; oleg@redhat.com;
>tglx@linutronix.de; mingo@elte.hu
>Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>
>Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
>Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
>Author:     Ingo Molnar <mingo@elte.hu>
>AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
>Committer:  Ingo Molnar <mingo@elte.hu>
>CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
>
>Revert "x86, bts: reenable ptrace branch trace support"
>
>This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
>
>A late objection to the ABI has arrived:
>
>   http://lkml.org/lkml/2009/6/10/253

I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.

Peters concerns were that Debug Store details are exposed to user space, which is
not the case. Debug Store itself is fully in-kernel and the expectation of a 
user-defined buffer can be implemented on top of the Debug Store changes that
Peter expects are needed to support PEBS.

A user-defined trace buffer size is required to support different usage models.
Some users only need a small amount of trace, whereas others need a big amount.
The interface will have to reflect that in some way.


regards,
markus.

---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
