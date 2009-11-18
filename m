Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZKRANj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZKRANj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZKRANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:13:39 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54384 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZKRANi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:13:38 -0500
Message-ID: <4B033C2B.5000504@us.ibm.com>
Date: Tue, 17 Nov 2009 16:13:31 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com>
In-Reply-To: <20091117074655.GA14023@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> Hi,
> 
> I would like to propose adding a new FUTEX_SET_WAIT operation to the futex
> code, as per the following patch against 2.6.32-rc7

If we go ahead with this, I'd like to adapt FUTEX_WAIT_REQUEUE_PI to use 
this as well, as it faces all the same races related to the calling task 
getting to sleep in the kernel before a wake call (FUTEX_CMP_REQUEUE_PI 
in this case) as futex_wait does. FUTEX_SET_WAIT_REQUEUE_PI is 
ridiculously long... but it is what it is I guess :-)

-- 
Darren "not-as-brave-as-peterz (short quote for Linus)" Hart
IBM Linux Technology Center
Real-Time Linux Team
