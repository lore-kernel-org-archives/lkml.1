Return-Path: <linux-kernel-owner+w=401wt.eu-S935279AbZDCSwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbZDCSwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZDCSwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:52:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZDCSwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:52:44 -0400
Message-ID: <49D65ADA.5040304@kernel.org>
Date: Fri, 03 Apr 2009 11:52:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Ingo Molnar <mingo@elte.hu>, Tom Talpey <tmtalpey@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       chuck.lever@oracle.com
Subject: Re: [PATCH] nfs: fix nfs_parse_mount_options() double kfree()
References: <86802c440904021512o2405ffa2gcbe057b9f81d5a46@mail.gmail.com>	 <20090402222106.GC9239@elte.hu> <49D56415.1080402@kernel.org>	 <84144f020904022252v2dbc18f5o35cc9737bf6d146d@mail.gmail.com>	 <20090403071638.GB14498@elte.hu>	 <49d5fe00.86c3f10a.0641.ffffbbdd@mx.google.com>	 <20090403130724.GA26365@elte.hu> <1238765148.7815.2.camel@heimdal.trondhjem.org>
In-Reply-To: <1238765148.7815.2.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Fri, 2009-04-03 at 15:07 +0200, Ingo Molnar wrote:
>> * Tom Talpey <tmtalpey@gmail.com> wrote:
>>
>>> At 03:16 AM 4/3/2009, Ingo Molnar wrote:
>>>> Impact: fix crash
>>>>
>>>> Yinghai Lu reported the following crash:
>>> This has to have been a merge problem, I moved a single kfree() 
>>> down a few lines in order to use the pointer in a second context. 
>>> With the moved line, it had been running successfully in Trond's 
>>> tree and linux-next for several weeks.
>> Maybe the tree got rebased and that introduced this merge artifact? 
> 
> No, but the linux-next tree also contained cachefs, which hasn't been
> merged yet. Let's keep an eye out when it does...

could be merging sequence.

YH
