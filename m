Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZIIT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZIIT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZIIT0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:26:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbZIIT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:26:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Cf3hUCDR6DrbzVC3u6wc8tZFub9AakzoDVtEkUzSVNL6nTgoZ4WujaMJWLRrJKYWf
	CjA99v5hQvomozhrRlelQ==
Date: Wed, 9 Sep 2009 12:26:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] Document flexible arrays
In-Reply-To: <20090909071352.33d204b1@bike.lwn.net>
Message-ID: <alpine.DEB.1.00.0909091222310.32267@chino.kir.corp.google.com>
References: <20090908175603.2bb02032@bike.lwn.net> <alpine.DEB.1.00.0909081714150.6263@chino.kir.corp.google.com> <20090909071352.33d204b1@bike.lwn.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Jonathan Corbet wrote:

> > Hmm, there are a number of changes in -mm that conflict with the 
> > description given in this document (element poisoning, DEFINE_FLEX_ARRAY, 
> > array shrinking, etc).  Perhaps this could be based on the -mm behavior 
> > and get pushed through Andrew so that it's consistent when merged for 
> > 2.6.32?
> 
> I've seen those patches going by.  The problem is that documenting
> existing, in-mainline APIs is challenging enough; trying to document
> maybe-next-release versions is a recipe for frustration.  So I'd really
> rather start with a document that describes the current state of the
> art; I promise I'll update it when the other changes go in.
> 

If you're going to push it yourself, I guess that's fine.  But if it's 
going through -mm, I don't think it would be helpful for the documentation 
to be inconsistent with the library in that kernel.  I'll probably be 
forced to update it myself when the changes are merged by Linus.
