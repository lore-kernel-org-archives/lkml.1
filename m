Return-Path: <linux-kernel-owner+w=401wt.eu-S933969AbYEBAkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbYEBAkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYEBAkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:40:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:32376 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbYEBAkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:40:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,424,1204531200"; 
   d="scan'208";a="277048532"
Date: Thu, 1 May 2008 17:39:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Tom Rini <trini@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502003947.GB28173@linux-os.sc.intel.com>
References: <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org> <20080501232116.GD4354@smtp.west.cox.net> <20080501233038.GA20601@linux-os.sc.intel.com> <alpine.LFD.1.10.0805011729540.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011729540.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 05:34:34PM -0700, Linus Torvalds wrote:
> Is it always about inlining? If so, can't we add a __noinline__ to the 
> declaration of __weak?

We tried that and it was still getting inlined.

thanks,
suresh
