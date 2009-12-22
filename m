Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZLVNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZLVNIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZLVNI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:08:29 -0500
Received: from web113309.mail.gq1.yahoo.com ([98.136.167.9]:48062 "HELO
	web113309.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751165AbZLVNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:08:28 -0500
Message-ID: <787373.9318.qm@web113309.mail.gq1.yahoo.com>
X-YMail-OSG: kwXfo5UVM1nTpZRwOPhNm0VjRACOvzJpAOs0OEJYPbGm1ctxn13hgMhZz1cz3I_XalP1F_ZMasGfxylafsrxAn3q5LbqZMdzXN.8cHgMxBCoIKwL5PlnOB2akOQ2YGilTCMQ9UZ3VFUeq6xImMXKNnrDSTPe7ZcGMGxsPAKTqcjfpD.tfb6sGnTUCgNyQN9RhPCCFCSilODgJhijQri1kxkYL8jl9hAtc_zD1qFtyXpK.EtYvuaJU.GTN0Dj5TldJWWOCmGTQdcx8QvaYFzvW7EqTqm4H2.2eCIN3s.FBnMA7rbWyt.mdlWQBt4T1kaD1w1D6Lk6Ilr5esd.0uscaUh6_Nx8vojSJcjvs8tF
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
References: <1261015420.1947.54.camel@serenity> <1261037877.27920.36.camel@laptop> <20091219122033.GA11360@localhost> <1261232747.1947.194.camel@serenity> <20091222015907.GA6223@localhost>
Date: Tue, 22 Dec 2009 05:01:46 -0800 (PST)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [PATCH] improve the performance of large sequential write NFS workloads
To: Wu Fengguang <fengguang.wu@intel.com>, Steve Rago <sar@nec-labs.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
       "jens.axboe" <jens.axboe@oracle.com>
In-Reply-To: <20091222015907.GA6223@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Wu Fengguang <fengguang.wu@intel.com>
> To: Steve Rago <sar@nec-labs.com>
> Cc: Peter Zijlstra <peterz@infradead.org>; "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>; jens.axboe <jens.axboe@oracle.com>
> Sent: Tue, December 22, 2009 2:59:07 AM
> Subject: Re: [PATCH] improve the performance of large sequential write NFS workloads
> 

[big snip]

> 
> In general it's reasonable to keep NFS per-file nr_dirty low, however
> questionable to do per-file nr_writeback throttling. This does not
> work well with the global limits - eg. when there are many dirty
> files, the summed-up nr_writeback will still grow out of control.
> And it's more likely to impact user visible responsiveness than
> a global limit. But my opinion can be biased -- me have a patch to
> do global NFS nr_writeback limit ;)
> 


 is that  "NFS: introduce writeback wait queue", which you sent me a while ago and I did not test until now :-( ?

Cheers
Martin
