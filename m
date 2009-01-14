Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZANSFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZANSFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZANSF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:05:29 -0500
Received: from mga05.intel.com ([192.55.52.89]:7684 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbZANSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:05:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,263,1231142400"; 
   d="scan'208";a="422370496"
Message-ID: <496E297B.6010100@linux.intel.com>
Date: Wed, 14 Jan 2009 19:05:47 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tim Hockin <thockin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>	 <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>	 <496DB067.6060402@linux.intel.com> <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>
In-Reply-To: <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> From my point of view: a single, consistent, easy logging interface
> for the kernel to send *structured data* about hardware/system events
> and errors up to userspace.

Which kinds of events were you thinking of?

So far we managed by cramming some other CPU events like thermal
trip into "pseudo banks" in struct mce. Admittedly it's not the
most pretty solution in the world, but it worked.

-Andi
