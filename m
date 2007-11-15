Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXKOStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXKOStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764788AbXKOStk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:49:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:37948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759533AbXKOStj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:49:39 -0500
Date: Thu, 15 Nov 2007 10:49:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jonathan Corbet <corbet@lwn.net>
cc: andi@firstfloor.org, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.215306.78239549.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
 <20071113.201853.40241484.davem@davemloft.net>
 <Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
 <20071113.215306.78239549.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well there is an LWN article now that also claims that the cpu_alloc 
patchset requires a large bss space. Sigh. See

http://lwn.net/Articles/257828/

Not true! 44 bytes is reasonable.

christoph@stapp:~/linux-2.6$ size mm/cpu_alloc.o
   text    data     bss     dec     hex filename
   5625      36      44    5705    1649 mm/cpu_alloc.o

Need to separate out the virtualization into a separate patch in V2 to 
make clear that it is there.


