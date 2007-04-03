Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXDCR1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXDCR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965959AbXDCR1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:27:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbXDCR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:27:39 -0400
Date: Tue, 3 Apr 2007 19:27:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403172736.GA23689@one.firstfloor.org>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46128C1B.1090900@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:17:15AM -0700, Ulrich Drepper wrote:
> Andi Kleen wrote:
> > There was a proposal some time ago to put that into the ELF aux vector
> > Unfortunately there was disagreement on what information to put 
> > there exactly (full topology, only limited numbers etc.) 
> 
> Topology, yes, I'm likely in favor of it.

What topology and what use case? 
 
> Processor number: no.  Unless you want to rip out hotpluging.  I'm

Topology is dependent on the number of CPUs.

Hot plugging is a completely orthogonal problem. Even your original
proposal wouldn't address it. Mine doesn't neither, because i suspect
most programs won't care. If it's addressed it could work
on top of it. The aux vector to get the information quickly at 
program startup and later updates can get it from /sys.

If some program starts caring we would need to implement some notification
mechanism (that would be possible), but it might be hard to fit
into glibc because you don't have a event loop.

-Andi
