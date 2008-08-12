Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYHLGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYHLGul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHLGuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:50:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59257 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYHLGuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:50:13 -0400
Message-ID: <48A131D3.9020902@cs.helsinki.fi>
Date: Tue, 12 Aug 2008 09:46:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: mathieu.desnoyers@polymtl.ca, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kmemtrace: SLAB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
In-Reply-To: <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> This adds hooks for the SLAB allocator, to allow tracing with kmemtrace.
> 
> We also convert some inline functions to __always_inline to make sure
> _RET_IP_, which expands to __builtin_return_address(0), always works
> as expected.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Applied, thanks!
