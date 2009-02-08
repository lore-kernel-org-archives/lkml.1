Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZBHBNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZBHBNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 20:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZBHBN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 20:13:29 -0500
Received: from ozlabs.org ([203.10.76.45]:49458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBHBN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:13:29 -0500
From: Michael Neuling <mikey@neuling.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linuxppc-dev@ozlabs.org, Anton Blanchard <anton@samba.org>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] bootgraph: fix for use with dot symbols 
In-reply-to: <20090128105601.GB18368@kryten> 
References: <19599.1233113450@neuling.org> <497FE4E7.8070303@linux.intel.com> <20090128105601.GB18368@kryten>
Comments: In-reply-to Anton Blanchard <anton@samba.org>
   message dated "Wed, 28 Jan 2009 21:56:01 +1100."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Sun, 08 Feb 2009 11:57:25 +1100
Message-ID: <18314.1234054645@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > question for the ppc folks.... why does the "print symbol" magic format str
ing
> > thing print a dot symbol and not the real function name?
> > Should that be fixed instead?
> 
> We have two symbols for each function, foo points to the function
> descriptor, and .foo points to the instruction text. If we were to strip
> the '.' when we print symbols then it would become harder to diagnose
> some failures (eg branching to the function descriptor instead of the
> instruction text).

Arjan,

I don't think there is much scope for removing dot symbols in the near
future.

Can you please take the patch as is for now so bootgraph will at least
work for existing systems?

Mikey
