Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbXEaSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbXEaSbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbXEaSbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:31:07 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:41373 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758544AbXEaSbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:31:05 -0400
Message-ID: <465F1479.70100@cfl.rr.com>
Date: Thu, 31 May 2007 14:31:21 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Jens Axboe <jens.axboe@oracle.com>, david@lang.hm,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com>
In-Reply-To: <20070531070307.GK85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 18:31:17.0633 (UTC) FILETIME=[E09DDF10:01C7A3B1]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15210.000
X-TM-AS-Result: No--3.560600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> That sounds like a good idea - we can leave the existing
> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> behaviour that only guarantees ordering. The filesystem can then
> choose which to use where appropriate....

So what if you want a synchronous write, but DON'T care about the order? 
   They need to be two completely different flags which you can choose 
to combine, or use individually.

