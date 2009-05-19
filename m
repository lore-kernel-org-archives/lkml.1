Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZESB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZESB3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZESB3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:29:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:47975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZESB3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:29:23 -0400
Message-ID: <4A120B47.8060200@kernel.org>
Date: Tue, 19 May 2009 10:28:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org>	 <1242674444.27006.8691.camel@localhost.localdomain>	 <4A11B9E7.8010707@zytor.com> <1242680835.27006.8734.camel@localhost.localdomain>
In-Reply-To: <1242680835.27006.8734.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 01:28:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh.

Suresh Siddha wrote:
> This %gs:absolute type accesses are for static percpu data.
> 
> But what I was referring to is the dynamic percpu data(accessed through
> per_cpu_ptr()). Instead of combining some part of the dynamic percpu
> data into  the static percpu data(first percpu chunk), we can use
> different chunks for dynamic percpu data and governed by a different
> per_cpu_dynamic_offset[NR_CPUS] array.
> 
> Then we can use large-page kernel direct mappings for static percpu data
> (or %gs:offset) and small-page vmalloc mappings for dynamic percpu data.

Hmmm... I can't really follow what you're suggesting.  Can you please
explain it in more detailed way?

Thanks.

-- 
tejun
