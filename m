Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYARQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYARQIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYARQIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:08:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYARQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:08:14 -0500
Date: Fri, 18 Jan 2008 17:07:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080118160757.GA24507@elte.hu>
References: <200801161114.239449000@suse.de> <20080118153325.GA11759@elte.hu> <20080118155650.GA20054@elte.hu> <200801181701.04549.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181701.04549.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > could you please make your queue bisectable?
> 
> The idea was that you git revert the original patches I referenced and 
> then drop the undo patches since I reimplement all that in different 
> ways (except for the white space changes, but that can be redone once 
> everything settled down again). Then it will be bisectable.

and how does that again make things bisectable in the middle of the PAT 
queue? For example if i undo:

  Subject: x86: pat: cpa, 32-bit
  From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

in the PAT series, the rest of PAT wont apply. The proper approach is to 
do incremental updates to the existing codebase, i.e. truly base CPA 
ontop of PAT.

about whitespaces:

> (except for the white space changes, but that can be redone once 
> everything settled down again). Then it will be bisectable.

it's a revert barrier (within v2.6.25), so it would be nicer and more 
maintainable to integrate the whitespace changes into your patches, via 
the method i suggested. (it can even be scripted up)

	Ingo
