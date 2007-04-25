Return-Path: <linux-kernel-owner+w=401wt.eu-S2992797AbXDYQIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992797AbXDYQIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992800AbXDYQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:08:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50186 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992797AbXDYQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:08:48 -0400
Date: Wed, 25 Apr 2007 18:08:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] on-demand readahead
Message-ID: <20070425160844.GA30132@one.firstfloor.org>
References: <377506695.54393@ustc.edu.cn> <p73odlc34ga.fsf@bingen.suse.de> <20070425160400.GA27954@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425160400.GA27954@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, the on-demand readahead can avoid _all_ lookups for small in-cache files.

How?

> But what do you mean by AS?

struct address_space

> > You seem to have a lot of magic numbers. They probably all need symbols and 
> > explanations.
> 
> The magic numbers are for easier testings, and will be removed in
> future.  For now, they enables convenient comparing of the two
> algorithms in one kernel.

I mean the 16 and 4 not the sysctl

> 
> If this new algorithm has been further tested and approved, I'll
> re-submit the patch in a cleaner, standalone form. The adaptive
> readahead patches can be dropped then. They may better be reworked as
> a kernel module.

If they actually help and don't cause regressions they shouldn't be a module, 
but integrated eventually Just it has to be all step by step.
> 
> > Your white space also needs some work.
> 
> White space in patch description?

In the code indentation.

-Andi
