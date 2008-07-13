Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYGMSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYGMSVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYGMSUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:20:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbYGMSUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:20:47 -0400
Date: Sun, 13 Jul 2008 11:20:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807131117530.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> 
 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>  <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>  <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org>  <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com> 
 <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>  <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org> <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Dmitry Adamushko wrote:
> 
> Yes, I agree. And I did _not_ say that the current design is sane. My
> impression about changes acceptable during a late release cycle was
> utterly CRAPPY (indeed, it's always better to immediately fix a
> problem the right way, not just add another patch and pray it doesn't
> break somewhere else).

I do agree that since I really want to do 2.6.26 (and I don't think this 
single issue is worth holding anything up for, considering that we do have 
a tested and understood patch - I was worried for a while), for now we'll 
do the minimal thing, and release 2.6.26 with just that.

I just want the longer-term strategy to be something more understandable 
that doesn't depend on very subtle ordering of various different callback 
functions etc.

			Linus
