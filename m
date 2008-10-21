Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYJUXDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYJUXDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYJUXDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:03:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:12566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYJUXDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,460,1220252400"; 
   d="scan'208";a="454046419"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>
Date: Tue, 21 Oct 2008 16:02:03 -0700
Subject: RE: [PATCH 2/2] i7300_idle driver v1.55
Thread-Topic: [PATCH 2/2] i7300_idle driver v1.55
Thread-Index: AckzyoPoVF+7+ni4QOOV1zHbLlUVhQAAqP5Q
Message-ID: <7E82351C108FA840AB1866AC776AEC4637CD28F4@orsmsx505.amr.corp.intel.com>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
	<e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
	<20081011083347.GA31918@elte.hu>
	<alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
 <20081020103214.072e3b5f.randy.dunlap@oracle.com>
 <7E82351C108FA840AB1866AC776AEC4637CD2743@orsmsx505.amr.corp.intel.com>
 <48FE546B.4000003@oracle.com>
In-Reply-To: <48FE546B.4000003@oracle.com>
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



>-----Original Message-----
>From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>Sent: Tuesday, October 21, 2008 3:15 PM
>To: Pallipadi, Venkatesh
>Cc: Randy Dunlap; Len Brown; Ingo Molnar;
>linux-acpi@vger.kernel.org; Linux Kernel Mailing List;
>Henroid, Andrew D; Linus Torvalds; Thomas Gleixner; H. Peter
>Anvin; Andi Kleen
>Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
>
>Pallipadi, Venkatesh wrote:
>> Thanks for the review. Some comments below.
>>
>> Thanks,
>> Venki
>>
>>> What is debugfs used for?  any docs for it?
>>
>> It has some statistics about how many times we went
>> into "memory throttling" state and how long we stayed
>> there since the boot. And one tunable that tunes a
>> parameter changing the policy to start throttling.
>> Will document this with an update patch.
>
>"Normal" tunables should be in sysfs, not debugfs.
>Or is this just a debugging tunable?
>
>You surely can't be certain (or require) that debugfs
>be available.
>

The lone tunable is debug only. It needs driver to be
compiled with DEBUG flag to be present in debugfs.
We don't want export it in sysfs and some random user
app starts using it and then end up providing backward
compatibility for it in future.

The other two read only variables give some stats about
the driver usage and also kind of debuggish info that
we used during development. Didn't seem worthy enough
to go under sysfs.

Thanks,
Venki
