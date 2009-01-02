Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZABQKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZABQKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZABQKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:10:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46510 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbZABQKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:10:00 -0500
Date: Fri, 2 Jan 2009 17:09:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [patch] x86: Fix incorrect __read_mostly on _boot_cpu_pda
Message-ID: <20090102160949.GF1180@elte.hu>
References: <20081231214446.GA6856@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231214446.GA6856@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
> to remove static boot cpu pdas introduced a bug.  _boot_cpu_pda is the
> actual pda used by the boot cpu and is definitely not "__read_mostly" and
> ended up polluting the read mostly section with writes.  This bug caused
> regression of about 8-10% on certain syscall intensive workloads.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

applied to tip/x86/urgent, with a Cc: stable tag. Thanks,

	Ingo
