Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZHZR37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZHZR37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZHZR36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:29:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbZHZR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:29:58 -0400
Message-ID: <4A956FB3.5030400@zytor.com>
Date: Wed, 26 Aug 2009 10:24:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
References: <20090825141547.GE6114@nowhere>	 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>	 <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere>	 <20090825173107.GJ6114@nowhere>  <20090825183119.GC2448@Krystal> <1251270602.7538.1228.camel@twins>
In-Reply-To: <1251270602.7538.1228.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 12:10 AM, Peter Zijlstra wrote:
> On Tue, 2009-08-25 at 14:31 -0400, Mathieu Desnoyers wrote:
>> For instance, some
>> proprietary Linux driver does very odd things with system calls within
>> kernel threads, like invoking them with int 0x80.
> 
> So who is going to send the x86 patch to make int 0x80 from kernel space
> panic the machine? :-)

Panicing might be a pretty darn good idea, since $DEITY knows what state
your stacks are in at that point, and if it is about to overflow.

... besides all the other evilness that entails.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

