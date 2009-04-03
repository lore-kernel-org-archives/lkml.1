Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbZDCN0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbZDCN0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZDCNZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:25:55 -0400
Received: from mx2.netapp.com ([216.240.18.37]:20513 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZDCNZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:25:54 -0400
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="149691785"
Subject: Re: [PATCH] nfs: fix nfs_parse_mount_options() double kfree()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Talpey <tmtalpey@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Yinghai Lu <yinghai@kernel.org>, David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       chuck.lever@oracle.com
In-Reply-To: <20090403130724.GA26365@elte.hu>
References: <86802c440904021512o2405ffa2gcbe057b9f81d5a46@mail.gmail.com>
	 <20090402222106.GC9239@elte.hu> <49D56415.1080402@kernel.org>
	 <84144f020904022252v2dbc18f5o35cc9737bf6d146d@mail.gmail.com>
	 <20090403071638.GB14498@elte.hu>
	 <49d5fe00.86c3f10a.0641.ffffbbdd@mx.google.com>
	 <20090403130724.GA26365@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 03 Apr 2009 09:25:48 -0400
Message-Id: <1238765148.7815.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 03 Apr 2009 13:25:52.0002 (UTC) FILETIME=[B5B23E20:01C9B45F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 15:07 +0200, Ingo Molnar wrote:
> * Tom Talpey <tmtalpey@gmail.com> wrote:
> 
> > At 03:16 AM 4/3/2009, Ingo Molnar wrote:
> > >
> > >Impact: fix crash
> > >
> > >Yinghai Lu reported the following crash:
> > 
> > This has to have been a merge problem, I moved a single kfree() 
> > down a few lines in order to use the pointer in a second context. 
> > With the moved line, it had been running successfully in Trond's 
> > tree and linux-next for several weeks.
> 
> Maybe the tree got rebased and that introduced this merge artifact? 

No, but the linux-next tree also contained cachefs, which hasn't been
merged yet. Let's keep an eye out when it does...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
