Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYAPWe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYAPWe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYAPW3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:29:44 -0500
Received: from colin.muc.de ([193.149.48.1]:2321 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053AbYAPW3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:29:42 -0500
Date: 16 Jan 2008 23:29:40 +0100
Date: Wed, 16 Jan 2008 23:29:40 +0100
From: Andi Kleen <ak@muc.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080116222940.GB39717@muc.de>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080116220153.GA39717@muc.de> <924EFEDD5F540B4284297C4DC59F3DEE5E8C86@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5E8C86@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. Printks are there. But are with KERN_DEBUG now. We should change
> them to WARNING atleast.

I'm pretty sure they were without KERN_* originally. Another reason
why the checkpatch.pl KERN_* warnings suck -- the original state would 
have been better and I bet you changed it just to shut up the dumb scripts.

-Andi
