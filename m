Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXEIWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXEIWs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbXEIWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:48:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49602 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbXEIWsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:48:43 -0400
Message-ID: <46424FC5.40804@garzik.org>
Date: Wed, 09 May 2007 18:48:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [bisect] NFS regression breaks X
References: <46423D62.2070200@garzik.org> <alpine.LFD.0.98.0705091440461.4062@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705091440461.4062@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Can you try it with this patch that re-introduces the "total overkill" 
> slack calculations, and probably makes them even worse (there's a few 
> left-shifts added, and now it will left-shift the extra slacktoo).

I'll try this patch, and separately, the Trond push that just appeared 
on LKML.

But after losing several hours discovering this "known issue," I need to 
attend to my own patches for today first.  So, testing won't be immediate.

	Jeff


