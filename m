Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbYLKVet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbYLKVet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYLKVe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:34:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:54893 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375AbYLKVe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:34:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,207,1228118400"; 
   d="scan'208";a="649036561"
Date: Thu, 11 Dec 2008 13:34:26 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       "nix.or.die@googlemail.com" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211213426.GA18346@linux-os.sc.intel.com>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain> <20081211163548.GA11859@elte.hu> <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain> <20081211203604.GA14817@elte.hu> <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 12:46:33PM -0800, Pekka Enberg wrote:
> Hi Ingo,
> 
> On Thu, Dec 11, 2008 at 10:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > ok. In this case i'd suggest we should just remove the warning. People do
> > get scared by needless kernel stack dumps - no matter whether it's marked
> > informational or not.
> >
> > So how about the patch below, queued up in tip/x86/debug? Arjan, what do
> > you think?
> 
> How come we don't put it under CONFIG_X86_DEBUG or something and hide
> somewhere in the "Kernel debugging" menu?

On the same lines, can we enable this check with a debug boot option?

thanks,
suresh
