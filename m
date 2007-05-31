Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXEaMII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXEaMII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXEaMH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:07:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbXEaMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:07:56 -0400
Date: Thu, 31 May 2007 14:07:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker II
Message-ID: <20070531120753.GA2538@one.firstfloor.org>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <465BECCC.5030001@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465BECCC.5030001@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, that is a very sensible idea.
> 
> > Possible further checks that might make sense:
> > - panic() anywhere in drivers/* 
> > - externs in .c files without asmlinkage
> > - general checking that everything in a fully visible {} block is the right 
> > indentation
> > 

Here are some more warnings I would like to see:

- Warning for any spinlock/mutex definition that doesn't have a comment
nearby (all locks ought to be documented) 
- Keep an ifdef count and give minus points for too many
- Warn about any architecture ifdefs (__i386__ etc.) 
While not 100% illegal this is definitely something that needs to be 
justified

-Andi

