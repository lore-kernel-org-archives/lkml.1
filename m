Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYJPIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYJPIaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYJPI3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:29:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:36126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYJPI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:29:51 -0400
Subject: Re: sched: only update rq->clock while holding rq->lock
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, shaggy@linux.vnet.ibm.com,
       brking@linux.vnet.ibm.com
In-Reply-To: <20081016023252.GA25969@linux.vnet.ibm.com>
References: <1224095843.28131.13.camel@twins>
	 <20081016023252.GA25969@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 10:29:42 +0200
Message-Id: <1224145782.28131.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 08:02 +0530, Srivatsa Vaddagiri wrote:
> On Wed, Oct 15, 2008 at 08:37:23PM +0200, Peter Zijlstra wrote:
> > Vatsa noticed rq->clock going funny and tracked it down to an update_rq_clock()
> > outside a rq->lock section.
> 
> For the records, actually Brian King and David Kleikamp noticed this!

Thanks Brian and Shaggy!


