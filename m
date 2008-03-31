Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYCaNPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYCaNPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYCaNPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:15:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbYCaNPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:15:12 -0400
Date: Mon, 31 Mar 2008 15:14:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/3] xen: Fix oops when mapping/unmapping addr above 1Gb
Message-ID: <20080331131442.GF14636@elte.hu>
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206722297-11763-1-git-send-email-markmc@redhat.com>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

>         In Fedora rawhide we're currently seeing oopses whenever a 
> processes dlopen()s a library which prelink() has previously relocated 
> above 1Gb. Some more details at:
> 
>   https://bugzilla.redhat.com/436453
> 
>         The issue seems to be that during xen_pgd_pin(), we only pin 
> PTE pages, but xen's release_pmd() tries to unpin PMD pages too.
> 
>         The following series of patches is against the latest x86 
> tree.

thanks, i've picked them up to get them tested - but it would be nice to 
have an ack from Jeremy as well. This seems like v2.6.25 material as 
well, right?

	Ingo
