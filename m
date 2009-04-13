Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZDMTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZDMTI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZDMTIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:08:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:17722 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751627AbZDMTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:08:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,180,1239001200"; 
   d="scan'208";a="447530965"
Message-ID: <49E38DBD.8040303@linux.intel.com>
Date: Mon, 13 Apr 2009 12:08:45 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: alan-jenkins@tuffmail.co.uk
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls -- 	infrastructure
References: <20090410103934.GA21506@elte.hu>	 <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com>	 <49E17A6E.5000104@zytor.com>	 <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain>	 <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com>	 <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu>	 <49E367E8.7080202@zytor.com> <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com>
In-Reply-To: <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> IIRC, the first person to report the issue found that it triggered
> when hotplugging a HDMI cable.

Oh, that's right.  Either we were invoking the video BIOS from the 
kernel (which we do actually do sometimes) -- in which case we have 
control over when it happens -- or there is commingling of the video 
BIOS and mainboard BIOS combined with SMM crap.  Joy.

	-hpa

