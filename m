Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbZCaPBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbZCaPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZCaPAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:00:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35642 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZCaPAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:00:50 -0400
Message-ID: <49D23016.4070706@us.ibm.com>
Date: Tue, 31 Mar 2009 08:00:38 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 3/8] RFC: futex: futex_lock_pi_atomic()
References: <20090330213306.606.9540.stgit@Aeon> <20090330213755.606.39013.stgit@Aeon> <alpine.LFD.2.00.0903310845550.12916@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903310845550.12916@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 30 Mar 2009, Darren Hart wrote:
>> +static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
>> +				union futex_key *key,
>> +				struct futex_pi_state **ps,
>> +				struct task_struct *task)
>> +{
>> +	u32 uval, newval, curval;
>> +	int lock_taken;
>> +	int ret;
>> +	int ownerdied = 0;
> 
>   int lock_taken, ret, ownerdied = 0;
>

Fixed, and reordered to meet preferred reverse line length order of 
declarations:

	int lock_taken, ret, ownerdied = 0;
	u32 uval, newval, curval;


Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
