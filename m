Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYAXQZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYAXQZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYAXQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:24:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753159AbYAXQY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:24:56 -0500
Message-ID: <4798BBD6.1020704@sgi.com>
Date: Thu, 24 Jan 2008 08:24:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: add percpu, cpu_to_node debug options
References: <20080122230409.198261000@sgi.com> <20080122230409.514557000@sgi.com> <20080124155938.GC4857@elte.hu>
In-Reply-To: <20080124155938.GC4857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> +config THREAD_ORDER
>> +	int "Kernel stack size (in page order)"
>> +	range 1 3
>> +	depends on X86_64
>> +	default "3" if X86_SMP
>> +	default "1"
>> +	help
>> +	  Increases kernel stack size.
> 
> you keep sending this broken portion, please dont ... 
> 
> 	Ingo

Sorry, I noted in the comments that that's only for the DEBUG patch, and
you shouldn't apply that, except when attempting to up the NR_CPUS count
for testing.  (I should perhaps just quit submitting it? ;-)

As a side note, soon we should be able to up NR_CPUS and not worry about
stack overflows.

Thanks,
Mike
