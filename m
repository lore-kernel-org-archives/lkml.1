Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbXFAVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbXFAVFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762893AbXFAVFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:05:44 -0400
Received: from sandeen.net ([209.173.210.139]:15030 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762864AbXFAVFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:05:43 -0400
Message-ID: <46608A26.3080605@sandeen.net>
Date: Fri, 01 Jun 2007 16:05:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <20070601211036.GA23975@duck.suse.cz>
In-Reply-To: <20070601211036.GA23975@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:

>> but iput goes
>> iput->iput_final->drop_inode->udf_drop_inode->lock_kernel() again
>   As Andrew already wrote, BKL is free to recurse...
> 
>> looking for the right way around it but figured I'd ping you early :)
>   Thanks for info - I'm now mostly out of email for a few days but I'll
> have a look at it as soon as I return.

Ok.  I was offbase in my first analysis (sorry!) but something -is- 
definitely locking up when I run fsstress, and w/o the patch mentioned 
it's ok.

I'm trying to manage to get it sorted but i'm out a couple of days now, too.

-Eric
