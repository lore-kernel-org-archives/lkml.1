Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYAVNYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYAVNYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYAVNX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:23:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:45294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYAVNX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:23:57 -0500
Date: Tue, 22 Jan 2008 14:23:55 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Message-ID: <20080122132355.GA24320@wotan.suse.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First priority is getting CPA and PAT consolidated before we put new

PAT seems to be still quite unstable and frankly for me it is 
unclear how long it will take to it become stable. It would
not surprise me if it takes longer than the .26 merge window.

You're saying you want to delay an relatively simple and imho
relatively mature feature like gbpages after that complicated and risky 
feature PAT? Please take a look at the patches; they're really
not very complicated.

That seems to me like against your own principles -- simple stuff
first -- that you two harped on so extensively on earlier this thread.

For me it would make much more sense to put the gbpages first
than to delay them for PAT. I only didn't argue this strongly
earlier because PAT was already rushed in (for me quite suprisingly) 
and I didn't want to argue for dropping it.

But now that it is gone again anyways delaying the gbpages for it again
would be quite unfortunate from my perspective.

-Andi
