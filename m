Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYKDOp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYKDOp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYKDOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:45:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36769 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193AbYKDOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:45:50 -0500
Date: Tue, 4 Nov 2008 08:45:49 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081104144549.GC30855@sgi.com>
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225809393.7803.1669.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:36:33PM +0100, Peter Zijlstra wrote:
> Or are folks disabling load-balance bottom-up, instead of top-down?
> 
> In that case, I think we should dis-allow that.

If what you mean by "disabling load-balance bottom-up" is disabling
load-balance in the root cpuset before disabling it in the leaves,
in the end it does not matter which way you do it, the setup winds up
being the same.
