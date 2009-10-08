Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbZJHOkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbZJHOkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZJHOkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:40:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbZJHOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:40:16 -0400
Date: Thu, 8 Oct 2009 07:39:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
In-Reply-To: <1255012399.4187.24.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, James Bottomley wrote:
> 
> So what do you want to do about this? 

I'm taking it (and the parisc one I was also unhappy with), but I'm a bit 
grumpy as usual. The parisc pull came totally outside the merge window, 
and the SCSI fix pull is technically perfectly fine, but what makes me 
grumpy is that I get the strong feeling that people aren't even _trying_ 
to hit the merge window with new drivers, because they decide that they 
instead can just push them any time.

So I don't think I necessarily want to change the "new driver" policy per 
se, but I want people to see the merge window as the _primary_ time you 
get any new code in. The "yes, we'll take new drivers" thing should be the 
exception rather than the rule. It doesn't seem to be an exception.

		Linus
