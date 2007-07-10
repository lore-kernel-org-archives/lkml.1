Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXGJQYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXGJQYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXGJQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:23:52 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:45076 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752956AbXGJQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:23:51 -0400
Message-ID: <4693B2A1.4090703@cfl.rr.com>
Date: Tue, 10 Jul 2007 12:24:01 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Ross Vandegrift <ross@kallisti.us>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: dump of ext3 very slow from dm LV
References: <20070630202821.GA2770@kallisti.us>
In-Reply-To: <20070630202821.GA2770@kallisti.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jul 2007 16:24:02.0014 (UTC) FILETIME=[B9F4DFE0:01C7C30E]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15290.000
X-TM-AS-Result: No--4.598300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Vandegrift wrote:
> I'm seeing speeds in the range of 3-4MiB/s.  If I increase dump's
> blocksize to 128KiB records, speed jumps up to about 20KiB/s, which
> is better but still frustratingly slow. Going to 1024KiB gets me
> about 28MiB/s.
> 
> Today I loop mounted a file on my LVM, filled it up with some crap
> from urandom and dumped it out.  I was able to get 50-60MiB/s.  
> 
> Is this amount of performance loss due to dm expected? My LV is just two
> SATA hard disks that I put into a VG. Stupid benchmarks with dd gives me
> a raw read speed from the LV of about 60MiB/sec.
> 
> I'm using kernel 2.6.18-4-686 from debian.  Any ideas on what's
> slowing down dump? 

My first impression is nothing is slowing things down.  This all appears 
normal.  Dumping or taring files in the filesystem isn't going to 
operate near the max sequential throughput of the drive.  Also you 
haven't tested without LVM so you have no basis to assume it is a 
problem with LVM.

