Return-Path: <linux-kernel-owner+w=401wt.eu-S939432AbZDJS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939432AbZDJS1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937542AbZDJS0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:26:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939001AbZDJS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:26:53 -0400
Date: Fri, 10 Apr 2009 11:20:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
In-Reply-To: <20090410180532.GA4419@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain>
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk>
 <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Ivan Kokshaysky wrote:
> 
> Actually, all of this has been discussed on lkml; here is the latest
> variant that makes everybody more or less happy, at least there are
> no objections from percpu folks and Martin (similar fix should work
> for s390 as well).

Is there any reason why this version of DEFINE_PER_CPU_SECTION wouldn't 
work on _any_ architecture? IOW, do we even need the #ifdef's and 
per-arch #define?

			Linus
