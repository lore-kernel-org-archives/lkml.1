Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYKEDa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYKEDa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYKEDaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:30:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53787 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbYKEDaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:30:18 -0500
Date: Wed, 5 Nov 2008 08:59:11 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081105032911.GC8304@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com> <20081104092040.781f9546.randy.dunlap@oracle.com> <20081105032440.GA3298@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105032440.GA3298@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:54:40AM +0530, Bharata B Rao wrote:
> I will resend the patch with other corrections you mentioned only if
> Paul/Ingo want this patch to go in.

I strongly recommend his patch to go in, as otherwise group accounting
will be broken where control hierarchy is not same as accounting
hierarchy. In that sense, I would treat this patch as more of a bug fix
than anything else.

- vatsa
