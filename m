Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXBMAR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXBMAR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXBMAR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:17:57 -0500
Received: from mga05.intel.com ([192.55.52.89]:21812 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030580AbXBMAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,160,1170662400"; 
   d="scan'208"; a="198888974:sNHT19231653"
Date: Mon, 12 Feb 2007 15:43:41 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [11/25] x86: default to physical mode on hotplug CPU kernels
Message-ID: <20070212154341.B15718@unix-os.sc.intel.com>
References: <200702101250.142420000@suse.de> <20070210115023.D19ED13DCE@wotan.suse.de> <m1vei9ymkh.fsf@ebiederm.dsl.xmission.com> <200702122336.23826.andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <200702122336.23826.andi@firstfloor.org>; from andi@firstfloor.org on Mon, Feb 12, 2007 at 11:36:23PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 11:36:23PM +0100, Andi Kleen wrote:
> True, that seems to be missing.
> 
> I agree that the patch seems to consist mostly of renaming doesn't make
> it any easier to read.
> 
> And it's worrying that it doesn't handle the hotplug case at all.

This patch is mostly a cleanup patch and doesn't have to do anything with
hotplug. I think the change log comment about hotplug kernel is a leftover
from an old patch.

> But I'm tempted to drop this unless the hotplug mystery can be cleared
> up. There was past information that logical is unsafe for hotplug.
> 
> Ingo? Suresh? 

logical clustered mode has problems with cpu hotplug.
( http://marc.theaimsgroup.com/?l=linux-kernel&m=113261865814107&w=2 )

I think logical flat is fine. We should be fine in logical flat, as long as
we are not using apic IPI shortcuts.

thanks,
suresh
