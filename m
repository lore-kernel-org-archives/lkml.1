Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZADEUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZADEUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZADEUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:20:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35767 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751731AbZADEUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:20:22 -0500
Message-ID: <49603902.40205@sgi.com>
Date: Sat, 03 Jan 2009 20:20:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64: cpumask fix for is_affinity_mask_valid()
References: <200901011149.18401.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <20090103115904.GA440@elte.hu> <200901041413.12187.rusty@rustcorp.com.au>
In-Reply-To: <200901041413.12187.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 03 January 2009 22:29:04 Ingo Molnar wrote:
>> update it to cpumask_var_t.
> 
> Please change it to a const struct cpumask_t *.
> 
> It should be const, and of course 'const cpumask_var_t' isn't the same.
> 
> Thanks,
> Rusty.

I have a fixup patch coming to correct that and remove an unneeded cpumask
off the stack.

Mike

