Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYHOPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYHOPP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYHOPPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:15:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYHOPPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:15:49 -0400
Date: Fri, 15 Aug 2008 17:15:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: peterz@infradead.org, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] reorder struct prop_local_single to remove padding on
	64 bit builds
Message-ID: <20080815151538.GG10029@elte.hu>
References: <1217594188.2953.24.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217594188.2953.24.camel@castor.localdomain>
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


* Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> reorder structure to remove 8 bytes of padding on 64 bit builds
> 
> (also removes 8 bytes from task_struct)

applied all 3 patches to tip/sched/devel - thanks Richard!

	Ingo
