Return-Path: <linux-kernel-owner+w=401wt.eu-S1422750AbXBAKlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422750AbXBAKlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422773AbXBAKlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:41:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXBAKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:41:51 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45BF3954.8050106@yahoo.com.au> 
References: <45BF3954.8050106@yahoo.com.au>  <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> 
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 01 Feb 2007 10:41:27 +0000
Message-ID: <3511.1170326487@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > + *  Determine whether some value is a power of two, where zero is
> > + * *not* considered a power of two.
> > + */
> 
> Why the qualifier? Zero *is* not a power of 2, is it?

The qualifier is worth leaving in the comment, just so that people who want to
use the function can be certain what it'll do for them.

David
