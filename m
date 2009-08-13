Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZHMJCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZHMJCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZHMJCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:02:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:47177 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753315AbZHMJCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:02:51 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX1+9PLM2YZG9AOcFeQDADZe0gxtM5Ot+rcdKXOJC2e
	uV8bkCgf2e0ohG
Date: Thu, 13 Aug 2009 11:03:35 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
Message-ID: <20090813090335.GA9502@mail1.bwalle.de>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
 <20090812124659.GA4808@mail1.bwalle.de>
 <4A837F49.9060003@redhat.com>
 <20090813053952.GA9037@mail1.bwalle.de>
 <4A83CCAA.1030302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A83CCAA.1030302@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Amerigo Wang <amwang@redhat.com> [2009-08-13 10:19]:
> Sure.
> 
> But if we disable CONFIG_KEXEC_AUTO_RESERVE, that means
> crashkernel=auto will be invalid, this is the same as it is now.

Ok, but since 'crashkernel=auto' is not used today, nobody has
'crashkernel=auto' in the bootloader configuration. So I don't see any
practial advantage of that config option.

Eric, what's your opinion on that, do we need a config option
CONFIG_KEXEC_AUTO_RESERVE or could we just implement that feature
unconditionally (if CONFIG_KEXEC is enabled, of course).


Regards,
Bernhard
