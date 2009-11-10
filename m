Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZKJBTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZKJBTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZKJBTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:19:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:10693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbZKJBTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:19:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,712,1249282800"; 
   d="scan'208";a="465826806"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Nix <nix@esperi.org.uk>, "Tantilov, Emil S" <emil.s.tantilov@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Nov 2009 17:19:14 -0800
Subject: RE: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP
	only? MSI? PAUSE!)
Thread-Topic: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP
	only? MSI? PAUSE!)
Thread-Index: Acphmgvl5K9PBnjEQve4+L2N/6DPmwACQA5g
Message-ID: <8DD2590731AB5D4C9DBF71A877482A903B4E371A@orsmsx509.amr.corp.intel.com>
References: <873a4rqu9o.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A1365F9923A504@rrsmsx501.amr.corp.intel.com>
	<87ljihnh81.fsf@spindle.srvr.nix> <87eio7meb4.fsf_-_@spindle.srvr.nix>
In-Reply-To: <87eio7meb4.fsf_-_@spindle.srvr.nix>
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

Not a fix, but a workaround.

It's not your gigabit switch either; it's a bug in the driver introduced in 2.6.30...sorry about that.  I'm working on a fix now that should be submitted upstream in the next few days.

Sorry for any inconvenience,
Bruce.

>-----Original Message-----
>From: Nix [mailto:nix@esperi.org.uk]
>Sent: Monday, November 09, 2009 4:09 PM
>To: Tantilov, Emil S
>Cc: e1000-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
>Subject: Re: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31
>(SMP only? MSI? PAUSE!)
>
>On 8 Nov 2009, nix@esperi.org.uk told this:
>
>> On 6 Nov 2009, Emil S. Tantilov verbalised:
>>> Also try disabling Tx pause frames:
>>> ethtool -A fastnet tx off autoneg off
>>
>> Trying that now. No freezes yet, but I haven't really given it long
>> enough.
>
>I just did a large number of kernel-build-and-installs with frame
>pointers over NFS over the errant link. No problems at all.
>
>I think we can say this fixes it (works around it?)
>
>Does this implicate the gigabit switch I'm talking to, or is it a kernel
>bug? (It looks like the cheap Realteks at the other ends of this link
>don't support pause frames at all: at least ethtool -a gives
>-EOPNOTSUPP, but maybe they simply can't be turned off... hm, r8169.c
>vaguely suggests that it supports them but can't turn them off without
>source hacking.)
>
>--------------------------------------------------------------------------
>----
>Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-
>Day
>trial. Simplify your report design, integration and deployment - and focus
>on
>what you do best, core application coding. Discover what's new with
>Crystal Reports now.  http://p.sf.net/sfu/bobj-july
>_______________________________________________
>E1000-devel mailing list
>E1000-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/e1000-devel
