Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYJPCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYJPCdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJPCdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:33:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48802 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYJPCdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:33:02 -0400
Date: Thu, 16 Oct 2008 08:02:52 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, shaggy@linux.vnet.ibm.com,
       brking@linux.vnet.ibm.com
Subject: Re: sched: only update rq->clock while holding rq->lock
Message-ID: <20081016023252.GA25969@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <1224095843.28131.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224095843.28131.13.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 08:37:23PM +0200, Peter Zijlstra wrote:
> Vatsa noticed rq->clock going funny and tracked it down to an update_rq_clock()
> outside a rq->lock section.

For the records, actually Brian King and David Kleikamp noticed this!

-- 
Regards,
vatsa
