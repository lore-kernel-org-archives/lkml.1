Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZLOBva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZLOBva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZLOBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:51:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36651 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZLOBv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:51:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B26EB81.4050200@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 10:50:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mce: rework output of MCE banks ownership information
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210727.456553000@alcatraz.americas.sgi.com> <20091116212251.GB2221@elte.hu> <4B01C59A.9050507@sgi.com> <4B024C76.9050005@jp.fujitsu.com> <4B02EE1D.6020302@sgi.com> <4B26B241.5010403@sgi.com>
In-Reply-To: <4B26B241.5010403@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2009/12/15 6:46), Mike Travis wrote:
> Hi Ingo,
> 
> When running the latest kernel, I still find these in the output:
> 
> 
> [    0.722553] Booting Node   0, Processors  #1
> [    0.811625] CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21
> [    0.812071]  #2
> [    0.907468] CPU 2 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21
> [    0.907918]  #3
> [    1.003311] CPU 3 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21
> [    1.003750]  #4
> 
> Was there anything else needed for this patch to be accepted? If it's
> not acceptable, would simply printing the above as DEBUG
> messages be acceptable?  (I'm aware you don't like printing
> summaries during init.)
> 
> Thanks,
> Mike

I have an updated patch, so let's continue on the new thread if needed.


Thanks,
H.Seto

