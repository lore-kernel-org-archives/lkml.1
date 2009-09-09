Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZIINNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZIINNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZIINNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:13:51 -0400
Received: from vena.lwn.net ([206.168.112.25]:41038 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZIINNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:13:51 -0400
Date: Wed, 9 Sep 2009 07:13:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] Document flexible arrays
Message-ID: <20090909071352.33d204b1@bike.lwn.net>
In-Reply-To: <alpine.DEB.1.00.0909081714150.6263@chino.kir.corp.google.com>
References: <20090908175603.2bb02032@bike.lwn.net>
	<alpine.DEB.1.00.0909081714150.6263@chino.kir.corp.google.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 17:20:16 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> Hmm, there are a number of changes in -mm that conflict with the 
> description given in this document (element poisoning, DEFINE_FLEX_ARRAY, 
> array shrinking, etc).  Perhaps this could be based on the -mm behavior 
> and get pushed through Andrew so that it's consistent when merged for 
> 2.6.32?

I've seen those patches going by.  The problem is that documenting
existing, in-mainline APIs is challenging enough; trying to document
maybe-next-release versions is a recipe for frustration.  So I'd really
rather start with a document that describes the current state of the
art; I promise I'll update it when the other changes go in.

Sound reasonable?

Thanks,

jon
