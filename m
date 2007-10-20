Return-Path: <linux-kernel-owner+w=401wt.eu-S936582AbXJTC6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936582AbXJTC6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXJTC60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:58:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbXJTC6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:58:25 -0400
Date: Fri, 19 Oct 2007 19:57:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NFS client fixes for 2.6.23++ 
In-Reply-To: <200710200244.l9K2i1ik016752@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0710191953230.3794@woody.linux-foundation.org>
References: <200710200244.l9K2i1ik016752@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Erez Zadok wrote:
> 
> i386

Hmm. Doesn't happen here, not on x86-64 nor i386.

Probably some subtle config issue as usual, where some configuration 
doesn't include <sched.h> indirectly.

But I'll add the direct includes of <linux/sched.h> and <linux/wait.h>. 

		Linus
