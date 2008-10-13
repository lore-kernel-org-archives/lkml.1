Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYJMSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYJMSjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYJMSjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:39:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:17776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbYJMSjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:39:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,404,1220252400"; 
   d="scan'208";a="626666727"
Date: Mon, 13 Oct 2008 11:39:42 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.27-git2] compilation warning for arch/x86/kernel/xsave.c
Message-ID: <20081013183940.GA7829@linux-os.sc.intel.com>
References: <48F1A789.3060707@numericable.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48F1A789.3060707@numericable.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 12:30:17AM -0700, Rufus & Azrael wrote:
> Hi Suresh,
> 
> 
> Your commit ed405958057ca6a8c4c9178a7a3b1167fabb45f5 causes this
> compilation warning on xsave.c :
> 
> > arch/x86/kernel/xsave.c: In function ‘save_i387_xstate’:
> > arch/x86/kernel/xsave.c:98: attention : ignoring return value of
> > ‘__clear_user’, declared with attribute warn_unused_result

Thanks Rufus for the report and thanks Ingo for pushing the fix.

I wonder why CONFIG_ENABLE_MUST_CHECK is not turned on by default?
I turned this option on, in the list of configs I use.

thanks,
suresh
