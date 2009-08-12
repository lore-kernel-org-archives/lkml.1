Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZHLMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZHLMqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZHLMqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:46:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:51585 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751415AbZHLMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:46:21 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX19u3oRxdjZudkmV2Gi+K8yPE45la7ZHGB50sZzSxS
	+OTvU1Yw/J2d19
Date: Wed, 12 Aug 2009 14:46:59 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
Message-ID: <20090812124659.GA4808@mail1.bwalle.de>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Amerigo Wang <amwang@redhat.com> [2009-08-12 10:15]:
> 
> This series of patch implements automatically reserved memory for crashkernel,
> by introducing a new boot option "crashkernel=auto". This idea is from Neil.

Honestly I don't see why everything is guarded by
CONFIG_KEXEC_AUTO_RESERVE. We do we need that new configuration
option? I mean, if I don't specify 'crashkernel=auto', then the patch
does nothing, right? Then the option CONFIG_KEXEC_AUTO_RESERVE would
only be needed so save some bytes of code. Is that really worth it?


Regards,
Bernhard
