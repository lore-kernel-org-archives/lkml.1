Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYBYPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYBYPwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYBYPwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:52:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45828 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYBYPwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:52:11 -0500
Date: Mon, 25 Feb 2008 21:31:55 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: revert load_balance_monitor()
Message-ID: <20080225160155.GC21903@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1203942167.6242.142.camel@lappy> <1203949799.4688.9.camel@homer.simson.net> <20080225143518.GA29275@linux.vnet.ibm.com> <1203953282.6242.180.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203953282.6242.180.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 04:28:02PM +0100, Peter Zijlstra wrote:
> Vatsa, would it make sense to take just that out, or just do a full
> revert?

Peter,
	6b2d7700266b9402e12824e11e0099ae6a4a6a79 and 
58e2d4ca581167c2a079f4ee02be2f0bc52e8729 are related very much. The
later changes how cpu load is calculated for the former to work
properly.

I would suggest we do a full revert for now, until the latency issues are sorted
out.

-- 
Regards,
vatsa
