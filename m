Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXDJRXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXDJRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXDJRXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:23:39 -0400
Received: from cs.columbia.edu ([128.59.16.20]:49965 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXDJRXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:23:38 -0400
Message-ID: <461BC7EC.5080101@cs.columbia.edu>
Date: Tue, 10 Apr 2007 13:22:52 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL -mm] Unionfs branch management code
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu> <20070409104948.2bc99202.akpm@linux-foundation.org>
In-Reply-To: <20070409104948.2bc99202.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, X-Seen-By filter1.cs.columbia.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon,  9 Apr 2007 10:53:51 -0400 "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu> wrote:
> 
>> The following patches introduce new branch-management code into Unionfs as
>> well as fix a number of stability issues and resource leaks.
> 
> I have a mental note that unionfs is in the "stuck" state, due to general
> agreement that we should implement this functionality at the VFS level, one
> reason for which is unionfs's upper-vs-lower coherency problems.

How can a union file system with a decent set of useful semantics be 
fully implemented at the VFS layer in a "clean" manner?

For instance, a major use of unionfs is live CDs, namely unionfs w/ a 
read-only and read-write layer.  Unionfs enables files to be copied up 
from the read-only layer to the read-write layer.

Does one really want to implement "copyup" in the VFS?

just my 2 agarot.
