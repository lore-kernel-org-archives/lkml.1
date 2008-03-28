Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYC1TTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYC1TTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYC1TTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:19:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:25916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYC1TTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:19:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="541803597"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 12:13:22 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEC83CDD@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200803281201.54380.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25 regression: powertop says 120K wakeups/sec
Thread-Index: AciRBjJVJZl6gSTjRUacvVu3g9e+PwAAOnJA
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080322173500.7b8b6751.akpm@linux-foundation.org> <200803281201.54380.david-b@pacbell.net>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-acpi@vger.kernel.org>, "Len Brown" <lenb@kernel.org>
X-OriginalArrivalTime: 28 Mar 2008 19:11:20.0175 (UTC) FILETIME=[81652FF0:01C89107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net] 
>Sent: Friday, March 28, 2008 12:02 PM
>To: Andrew Morton; Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org; Rafael J. Wysocki; 
>linux-acpi@vger.kernel.org
>Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
>
>On Saturday 22 March 2008, Andrew Morton wrote:
>> On Sat, 22 Mar 2008 13:24:54 -0700 David Brownell 
><david-b@pacbell.net> wrote:
>> 
>> > I noticed this with 2.6.25-rc2 (if not before), and the problem
>> > is still there with 2.6.25-rc6-git (as of this AM).
>
>A 2.6.24 kernel I still had stashed away didn't act odd; the
>problem joined us before 2.6.25-rc1 was tagged.
>

There was a fix that went in recently (one or two days back) that should
have fixed this.
Commit 8e92b6605da989

Can you check with latest git to see whether this is still a problem?

Thanks,
Venki
