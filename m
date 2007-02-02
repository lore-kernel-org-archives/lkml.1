Return-Path: <linux-kernel-owner+w=401wt.eu-S1946150AbXBBXCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150AbXBBXCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946152AbXBBXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:02:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946150AbXBBXCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:02:01 -0500
Date: Fri, 2 Feb 2007 15:01:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202224259.GB1212@elte.hu>
Message-ID: <Pine.LNX.4.64.0702021459550.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202195932.15b9b4ed@localhost.localdomain>
 <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
 <20070202213019.202e8db5@localhost.localdomain>
 <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
 <20070202224259.GB1212@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Ingo Molnar wrote:
> 
> but if the application /has/ identified fundamental parallelism, we 
> /must not/ shut that parallelism off by /designing/ this interface to 
> use the fibril thing which is a limited cooperative, single-CPU entity. 

Right. We should for example encourage people to use some kind of 
paralellizing construct. 

I know! We could even call them "threads", so to give people the idea that 
they are independent smaller entities in a thicker "rope", and we could 
call that bigger entity a "task" or "process", since it "processes" data.

Or is that just too far out?

			Linus
