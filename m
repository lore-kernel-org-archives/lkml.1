Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYJUWQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYJUWQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYJUWPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:15:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43108 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYJUWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:15:53 -0400
Message-ID: <48FE546B.4000003@oracle.com>
Date: Tue, 21 Oct 2008 15:15:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>	<e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>	<20081011083347.GA31918@elte.hu>	<alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <20081020103214.072e3b5f.randy.dunlap@oracle.com> <7E82351C108FA840AB1866AC776AEC4637CD2743@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4637CD2743@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> Thanks for the review. Some comments below.
> 
> Thanks,
> Venki
> 
>> What is debugfs used for?  any docs for it?
> 
> It has some statistics about how many times we went
> into "memory throttling" state and how long we stayed
> there since the boot. And one tunable that tunes a
> parameter changing the policy to start throttling.
> Will document this with an update patch.

"Normal" tunables should be in sysfs, not debugfs.
Or is this just a debugging tunable?

You surely can't be certain (or require) that debugfs
be available.

~Randy
