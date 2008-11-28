Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYK1AQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYK1AQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 19:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYK1AQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 19:16:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:28872 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYK1AQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 19:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iAQEriYArtawVlPDzTTeCqJzS0FF5t0ZYaVcxFJYgXNxmU7H8cDTlRulN+Ek7cE365
         fdzMp/WcMcm1e+wsh2JSCN4Y06Hj6vZ4lb2IZI8ehh3qci0lQwBt09mgZq3l2XB219L5
         n7db+GjuPPAjZ8oHDavEfbvqkfbqo3uGj6PJM=
Message-ID: <492F3847.2020204@gmail.com>
Date: Fri, 28 Nov 2008 01:16:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Hugh Dickins <hugh@veritas.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>  <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>  <Pine.LNX.4.64.0811271349040.21910@blonde.site> <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com> <Pine.LNX.4.64.0811271643250.9618@blonde.site> <alpine.DEB.1.10.0811271827490.7113@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0811271827490.7113@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt a écrit :
> [ Added Frederic ]
> 
> On Thu, 27 Nov 2008, Hugh Dickins wrote:
>>  					break;
>> --- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
>> +++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
>> @@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
>>  
>>  struct boot_trace {
>>  	pid_t			caller;
>> -	char			func[KSYM_NAME_LEN];
>> +	char			func[KSYM_SYMBOL_LEN];
>>  	int			result;
>>  	unsigned long long	duration;		/* usecs */
>>  	ktime_t			calltime;
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> The boot tracer was written by Frederic.
> 
> -- Steve
> 

No problem for me.
The ring buffer seems large enough to contain this entry size for each initcall :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

