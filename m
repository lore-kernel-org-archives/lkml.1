Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbYARTLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbYARTLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbYARTKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:10:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758568AbYARTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:10:52 -0500
Date: Fri, 18 Jan 2008 11:08:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: peterz@infradead.org, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
 <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org> <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org> <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Miklos Szeredi wrote:
> 
> But then background writeout, sync(2), etc, wouldn't update the times.

Sure it would, but only when doing the final unmap.

Did you miss the "on unmap and msync" part?

		Linus
