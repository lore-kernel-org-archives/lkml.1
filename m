Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYACXNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYACXNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYACXMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:12:52 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:42524 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYACXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:12:51 -0500
Date: Fri, 4 Jan 2008 00:12:50 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <andyw@uk.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20080104001250.6747701b@weinigel.se>
In-Reply-To: <477CFC89.1020409@panasas.com>
References: <20071202130335.690a8daf@cw05lap>
	<20080103111058.GE10861@shadowen.org>
	<20080103122610.GA18255@infradead.org>
	<20080103123036.GB29523@ghostprotocols.net>
	<477CFC89.1020409@panasas.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 17:17:29 +0200
Benny Halevy <bhalevy@panasas.com> wrote:

> On Jan. 03, 2008, 14:30 +0200, Arnaldo Carvalho de Melo
> > Agreed, CodingStyle is not about mindless consistency such as "for
> > (" is the right thing, so "list_for_each (" is consistent with it,
> > it is about codifying practice contributors got used to over the
> > years.
> > 
> 
> Why mindless?
> Coding style is also about giving the coding language logic a
> graphical representation.  Following a convention that flow control
> keywords such as "if", "for", or "while" are distinguished from
> function calls by use of a space after the keyword really helps the
> code readability regardless of how people used to code it in the
> past... The for_each_* macros are clearly not function calls but
> rather translate to for () flow control constructs hence they should
> follow the same convention. FWIW, I think that changing the existing
> convention is worth it in this case.

Definite agreement here, since _for_each is used for flow control, that
space should be there.  

And some people seem to take checkpatch.pl as the gospel, and won't
apply code with checkpatch warnings.

  /Christer
