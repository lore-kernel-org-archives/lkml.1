Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYHUHbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYHUHbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYHUHay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYHUHax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:30:53 -0400
Date: Thu, 21 Aug 2008 09:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
Message-ID: <20080821073020.GA28386@elte.hu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Oren Laadan <orenl@cs.columbia.edu> wrote:

>  checkpoint/ckpt_x86.c   |   28 ++++
>  checkpoint/rstr_x86.c   |    2 +

please move these into arch/x86/mm/checkpoint.c and 
arch/x86/mm/restore.c. (also, please dont try to abbreviate too much in 
filenames, makes it harder to follow changes later on, etc.)

Cool stuff btw! Any ETA on when more complex apps can be 
checkpointed/restored? Also, shouldnt at least part of this effort be 
joined with the live migration efforts of openvz? (or do you see 
fundamental, unsolvable differences?)

	Ingo
