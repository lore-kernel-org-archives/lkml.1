Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbYARTD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbYARTD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765412AbYARTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:03:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:36206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765397AbYARTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:03:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,217,1199692800"; 
   d="scan'208";a="291565102"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Fri, 18 Jan 2008 11:02:50 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <200801180846.03161.jesse.barnes@intel.com> <20080118181202.GA19889@one.firstfloor.org>
In-Reply-To: <20080118181202.GA19889@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181102.50629.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2008 10:12 am Andi Kleen wrote:
> I looked back then when I had bisected it down and I admit I didn't spot
> the problem from source review. I think it came from the reordering so
> blacklisting AMD alone wouldn't have helped. Might have been some
> subtle race (e.g. long ago we had such races in the MTRR code
> triggered by the first HT CPUs)
>
> Anyways I just test booted latest git-x86 with your patches included on
> the QC system and it booted now. However it has both more RAM and newer
> CPUs (the original ones were pre-production, that is why I also didn't send
> you logs[1] ..) then when I tested originally. So this means either the
> problem was somewhere else or the different configuration hides it.
>
> I guess you will hear about it if it's still broken on other machines.
>
> Currently it looks good.
>
> I think it should be enabled on AMD too though. If the reordering breaks
> it then blacklisting won't help anyways.
>
> -Andi
>
> [1] but I checked the known errata and there was nothing related to MTRR.

Ah, ok, that explains your reticence earlier.  Thanks for testing again, I 
guess the patch is good to go.

Jesse
