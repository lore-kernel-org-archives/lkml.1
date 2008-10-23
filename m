Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYJWQ0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYJWQ0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYJWQ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:26:42 -0400
Received: from mga10.intel.com ([192.55.52.92]:34110 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753101AbYJWQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:26:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,471,1220252400"; 
   d="scan'208";a="630867412"
Message-ID: <4900A5CA.5070107@linux.intel.com>
Date: Thu, 23 Oct 2008 18:26:50 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <48FE07AE.4010203@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com> <48FED3FA.6040703@linux.intel.com> <20081022234006.GB28775@linux-os.sc.intel.com> <48FFCF28.3070604@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637D389DB@orsmsx505.amr.corp.intel.com> <20081023150047.GD6368@linux.vnet.ibm.com>
In-Reply-To: <20081023150047.GD6368@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Suppose that one of the idle CPUs takes an interrupt, whose handler
> accesses the module being removed.  How is this handled?

We're just talking about idle notifier code here. Interrupts shouldn't
ever call idle notifiers directly.

-Andi
