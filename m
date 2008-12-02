Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYLBU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYLBU3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYLBU3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:29:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYLBU3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:29:44 -0500
Date: Tue, 2 Dec 2008 20:29:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alejandro Riveira Fern?ndez <ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202202941.GG28946@ZenIV.linux.org.uk>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org> <20081202194907.4eaffc0a@varda> <alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 11:23:42AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 2 Dec 2008, Alejandro Riveira Fern??ndez wrote:
> > 
> >  Here you go 
> > 
> >  [alex@varda:kernel/linux-2.6]$ git bisect bad                                   
> > 31168481c32c8a485e1003af9433124dede57f8d is first bad commit
> 
> Excellent. One last step - can you verify that just reverting this commit 
> makes your problems go away?

I would be _very_ surprised if it did; the only thing that could possibly
happen there is executing code from freed memory if the section changes
are fucked up and that definitely does not match the symptoms described.

