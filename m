Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbZJIOcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbZJIOcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbZJIOcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:32:12 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:60471 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbZJIOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:32:11 -0400
X-Loopcount0: from 10.9.160.253
Date: Fri, 9 Oct 2009 09:31:33 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Fwd: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091009143133.GC19218@mock.linuxdev.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com> <851fc09e0910082221q7f832c22xfc0d01ab72a97c3f@mail.gmail.com> <1255067727.5228.111.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255067727.5228.111.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 01:55:27PM +0800, Huang Ying wrote:
> Can you tell me where can I find more about PECI? Or you mean APEI (ACPI
> Platform Error Interfaces)?

Yes, APEI.  My mistake.  Too many acronyms for my little mind.

> We are working on APEI supporting now too, mainly on the general part.
> We will release the code after it passes our internal testing.

Excellent.  If you could post even the untested code, that would be
helpful. Do you have a timeline for publication?

My patch is fundamentally in response to the fact that your APEI code
is not present yet, and there is a problem seen at customer sites now
(particularly SLES 11, as that's the only "Enterprise"-class distro
version with the AER driver, but also any distro or kernel build that
includes the AER driver).  But without knowing when the rest of the
APEI code will land in mainline, I feel it would be safe to do the
minimum amount of HEST parsing, just enough to know if AER should be
disabled or not.  My patch can be considered "throw-away" code - to be
dropped when your APEI code lands in mainline and the distros.

> As H.Seto said, HEST table parsing code should go the general APEI
> supporting code. We have some HEST table parsing code, hope that can be
> used by your code too.

I agree completely.  But I need a solution in the short-term, both for
mainline and which can be backported, until your code is available.

I'm reworking my patch based on Seto-san's comments, and will repost
soon as linux-next stops crashing on me. :-)

Thanks,
Matt

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
