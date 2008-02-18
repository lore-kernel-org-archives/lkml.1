Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYBRIZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYBRIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYBRIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:25:16 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34546 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753765AbYBRIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:25:14 -0500
Date: Mon, 18 Feb 2008 13:54:47 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] reworking load_balance_monitor
Message-ID: <20080218082447.GA3823@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080214155724.772744000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214155724.772744000@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 04:57:24PM +0100, Peter Zijlstra wrote:
> Hi,
> 
> Here the current patches that rework load_balance_monitor.
> 
> The main reason for doing this is to eliminate the wakeups the thing generates,
> esp. on an idle system. The bonus is that it removes a kernel thread.
> 

Hi Peter,

The changes look really good to me. I will give it a run in sometime and
give some more feedback.

-- 
regards,
Dhaval
