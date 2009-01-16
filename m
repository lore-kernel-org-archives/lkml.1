Return-Path: <linux-kernel-owner+w=401wt.eu-S936295AbZAPSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936295AbZAPSzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZAPSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:55:30 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33319 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757307AbZAPSz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:55:29 -0500
Message-ID: <4970D81B.9000904@sgi.com>
Date: Fri, 16 Jan 2009 10:55:23 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ursula Braun <ursula.braun@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 3/5] cpumask: convert misc driver functions
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>	 <20090107195832.733912000@polaris-admin.engr.sgi.com> <12c511ca0901161042x5aab46edy70d0d89c84792cd9@mail.gmail.com>
In-Reply-To: <12c511ca0901161042x5aab46edy70d0d89c84792cd9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> +void __exit buffer_sync_cleanup(void)
> +{
> +	free_cpumask_var(marked_cpus);
> +}
> 
> This breaks ia64 with CONFIG_OPROFILE=y
> 
> `buffer_sync_cleanup' referenced in section `.init.text' of
> arch/ia64/oprofile/built-in.o: defined in discarded section
> `.exit.text' of arch/ia64/oprofile/built-in.o
> make: *** [.tmp_vmlinux1] Error 1
> 
> -Tony

Hi Tony,

Hmm, that is a tricky error.  I'll see what can be done to
eliminate it.

Thanks!
Mike


