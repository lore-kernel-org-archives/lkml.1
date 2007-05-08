Return-Path: <linux-kernel-owner+w=401wt.eu-S967898AbXEHTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967898AbXEHTT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967821AbXEHTTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:19:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967680AbXEHTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:19:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=NouEDmBxnBx/zjhbSp+Hb6PRqfdGfHyqboTwwbeTdHPIyV56PELbpgg7z8VIL1ZJU
	SFSh3rn5BRGI2mdV4YZwA==
Date: Tue, 8 May 2007 12:18:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <20070508121404.17bd97a6.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Randy Dunlap wrote:

> [well, can be turned into a patch]
> 
> Here are some 'volatile' comments from Linus, extracted from
> several emails in at least 2 threads.
> 
> If this is close to useful, we can add it to Documentation/.
> 
> ===============================================================
> 
> ***** "volatile" considered useless and evil:  Just Say NO! *****
> 
> Do not use the C-language "volatile" keyword
> (extracted from lkml emails from Linus)
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 

Since 'volatile' has two different semantics depending on the context in 
which it is used, this warning should be appended to include the fact that 
it is legitimate to use for inline assembly.
