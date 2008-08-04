Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYHDJdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYHDJdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYHDJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:33:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36754 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbYHDJdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:33:08 -0400
Message-ID: <4896CB22.4000005@melbourne.sgi.com>
Date: Mon, 04 Aug 2008 19:25:54 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
Organization: File Serving Technologies ; Silicon Graphics Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Bernd Schubert <bs@q-leap.de>
CC: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Michael Shuey <shuey@purdue.edu>,
       Shehjar Tikoo <shehjart@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, rees@citi.umich.edu, aglo@citi.umich.edu
Subject: Re: high latency NFS
References: <200807241311.31457.shuey@purdue.edu> <20080804003206.GB6119@disturbed> <20080804011158.GA8066@fieldses.org> <200808041118.19743.bs@q-leap.de>
In-Reply-To: <200808041118.19743.bs@q-leap.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:
> On Monday 04 August 2008 03:11:58 J. Bruce Fields wrote:
>   
>> OK, so to summarize: when the rate of incoming rpc's is very high (and,
>> I guess, when we're serving everything out of cache and don't have IO
>> wait), all the nfsd threads will stay runable all the time.  That keeps
>> userspace processes from running (possibly for "minutes").  And that's a
>> problem even on a server dedicated only to nfs, since it affects portmap
>> and rpc.mountd.
>>     
>
> Even worse, it affects user space HA software such as heartbeat and everyone 
> with reasonable timeouts will see spurious 'failures'. 
>   
We're seeing that problem right now, even with the patch.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.

