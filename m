Return-Path: <linux-kernel-owner+w=401wt.eu-S934624AbYEVIQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624AbYEVIQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762058AbYEVIQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:16:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33758 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761166AbYEVIQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:16:07 -0400
Date: Thu, 22 May 2008 10:15:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org,
       apw@shadowen.org, Franck Bui-Huu <fbuihuu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
	netfilter on __nf_ct_helper_find()
Message-ID: <20080522081546.GB7222@elte.hu>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au> <20080521113230.GA10830@linux.vnet.ibm.com> <20080521225214.507eb400.sfr@canb.auug.org.au> <4834239D.90500@linux.vnet.ibm.com> <20080522101148.fbabee96.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522101148.fbabee96.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Actually this is caused by the splitting out of the rcu stuff from 
> list.h that is in linux-next, sorry.

this bug has been fixed in the -tip tree 9 days ago:

|  commit db3c7a9f07a212d1774e6b432a08b231340e984d
|  Author: Ingo Molnar <mingo@elte.hu>
|  Date:   Tue May 13 15:37:05 2008 +0200

that commit was in intermediate testing phase in the 'scratch' branch, 
and a few days ago linux-next stopped picking up the scratch branch.

I've now cherry-picked this fix over into the rcu branch and everything 
should be fine again in the next linux-next iteration.

	Ingo
