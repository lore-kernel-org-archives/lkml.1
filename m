Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYGXXIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYGXXIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYGXXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:08:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:42790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbYGXXIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="364519569"
Date: Thu, 24 Jul 2008 16:06:59 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724230658.GP14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org> <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org> <20080724222523.GN14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> Hmm. In fact, I think that x86-64 version is actually only used in a
> single place - arch/x86/kernel/signal_64.c. So it's actively *wrong* to
> have that thing in a header file to begin with!

BTW, while you are at it, please move save_i387() aswell, to be consistent
and clean.

thanks,
suresh
