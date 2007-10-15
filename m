Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbXJOWv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbXJOWv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXJOWvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:51:19 -0400
Received: from gw.goop.org ([64.81.55.164]:51198 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbXJOWvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:51:18 -0400
Message-ID: <4713EEE5.8060706@goop.org>
Date: Mon, 15 Oct 2007 15:51:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 11/11] maps3: make page monitoring /proc file optional
References: <12.290135367@selenic.com> <1192488599.6118.100.camel@localhost>
In-Reply-To: <1192488599.6118.100.camel@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
>   
>> +config PROC_PAGE_MONITOR
>> +       default y
>> +       bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
>> +       help
>> +         Various /proc files exist to monitor process memory utilization:
>> +         /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
>> +         /proc/kpagecount, and /proc/kpageflags. Disabling these
>> +          interfaces will reduce the size of the kernel by approximately 4kb. 
>>     
>
> How about pulling the EMBEDDED off there?  I certainly want it for
> non-embedded reasons. ;)

That means it will only bother asking you if you've set EMBEDDED;
otherwise its always on.

    J
