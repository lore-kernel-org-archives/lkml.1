Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYJWKuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYJWKuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYJWKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:50:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYJWKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:50:03 -0400
Date: Thu, 23 Oct 2008 06:49:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wenji Huang <wenji.huang@oracle.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/13 v2] ftrace: clean ups and fixes
In-Reply-To: <490043DE.4000802@oracle.com>
Message-ID: <alpine.DEB.1.10.0810230646170.31277@gandalf.stny.rr.com>
References: <20081022212721.167005680@goodmis.org> <490043DE.4000802@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Wenji Huang wrote:

> Hi,
> just several trivial things.

Thanks,

> 
> [PATCH 02/13 v2] ftrace: dynamic ftrace process only text section
> +# Acceptible sections to record.
> 
> typo - Acceptible

Ah, it should be Acceptable.

> 
> [PATCH 03/13 v2] ftrace: return error on failed modified text.
> + * This is a very sensitive operatation and great care needs
> 
> typo - operatation

Sorry, I must have stuttered ;-)

> Why not put comments to function definition?

The function is arch dependent. And the comment here is also to help
the arch maintainers know what is needed of that function.

> 
> [PATCH 04/13 v2] ftrace: comment arch ftrace code
> +	 *  as well as code changing. We do this by using the
> +	 *  __copy_*_user functions.
> 
> According to [PATCH 05/13], change to using the proper API for reading and
> writing, not __copy_*_user.

Good catch. Thanks,

-- Steve
