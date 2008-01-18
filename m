Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYARW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYARW3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763266AbYARW3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:29:07 -0500
Received: from smtprelay13.ispgateway.de ([80.67.29.43]:37690 "EHLO
	smtprelay13.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762534AbYARW3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:29:05 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
Date: Fri, 18 Jan 2008 23:32:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       salikhmetov@gmail.com, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
References: <12006091182260-git-send-email-salikhmetov@gmail.com> <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182332.02945.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Friday 18 January 2008, Linus Torvalds wrote:
> On Fri, 18 Jan 2008, Miklos Szeredi wrote:
> > 
> > What I'm saying is that the times could be left un-updated for a long
> > time if program doesn't do munmap() or msync(MS_SYNC) for a long time.
> 
> Sure.
> 
> But in those circumstances, the programmer cannot depend on the mtime 
> *anyway* (because there is no synchronization), so what's the downside?

Can we get "if the write to the page hits the disk, the mtime has hit the disk
already no less than SOME_GRANULARITY before"? 

That is very important for computer forensics. Esp. in saving your ass!

Ok, now back again to making that fast :-)


Best Regards

Ingo Oeser
