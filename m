Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbZDXQRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbZDXQRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZDXQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:17:31 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:44729 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753862AbZDXQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:17:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwFAGp+8UlMQW1W/2dsb2JhbACBUM8Eg3QF
Date: Fri, 24 Apr 2009 12:12:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       stable@kernel.org, cpufreq@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rjw@sisk.pl, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq fix timer teardown in conservative governor
	(2.6.30-rc2)
Message-ID: <20090424161217.GA25650@Krystal>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424043546.GB8091@Krystal> <alpine.LFD.2.00.0904240217390.15843@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904240217390.15843@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:05:07 up 55 days, 12:31,  2 users,  load average: 0.25, 0.30,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown (lenb@kernel.org) wrote:
> Somebody please remind me why we are spending effort to 
> maintain the conservative governor instead of deleting it.
> 

Documentation/cpu-freq/governors.txt

"The CPUfreq governor "conservative", much like the "ondemand"
governor, sets the CPU depending on the current usage.  It differs in
behaviour in that it gracefully increases and decreases the CPU speed
rather than jumping to max speed the moment there is any load on the
CPU.  This behaviour more suitable in a battery powered environment."

So better battery usage seems to be the reason why conservative lives.

Mathieu


> thanks,
> Len Brown, Intel Open Source Technology Center
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
