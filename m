Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYACPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYACPRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYACPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:17:46 -0500
Received: from sa15.bezeqint.net ([192.115.104.30]:42323 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYACPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:17:45 -0500
Message-ID: <477CFC89.1020409@panasas.com>
Date: Thu, 03 Jan 2008 17:17:29 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
References: <20071202130335.690a8daf@cw05lap> <20080103111058.GE10861@shadowen.org> <20080103122610.GA18255@infradead.org> <20080103123036.GB29523@ghostprotocols.net>
In-Reply-To: <20080103123036.GB29523@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 03, 2008, 14:30 +0200, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> Em Thu, Jan 03, 2008 at 12:26:10PM +0000, Christoph Hellwig escreveu:
>> On Thu, Jan 03, 2008 at 11:10:58AM +0000, Andy Whitcroft wrote:
>>> We have had some stabs at changing this, but no consensus was reached on
>>> whether it was a "for" or a "function".  My memory is of there being
>>> slightly more "without a space" tenders than the other and so it has not
>>> been changed.  This thread also seems so far to have not really
>>> generated a concensus.  So I would tend to leave things as they are.  
>>>
>>> A third option might be to accept either on *for_each* constructs.
>>> That might tend to lead to divergance.  Difficult.  However, also see my
>>> later comments on "style guide".
>> Pretty much all core code uses list_for_each_entry( so new code should
>> follow that example.
> 
> Agreed, CodingStyle is not about mindless consistency such as "for (" is
> the right thing, so "list_for_each (" is consistent with it, it is about
> codifying practice contributors got used to over the years.
> 

Why mindless?
Coding style is also about giving the coding language logic a graphical
representation.  Following a convention that flow control keywords
such as "if", "for", or "while" are distinguished from function calls
by use of a space after the keyword really helps the code readability
regardless of how people used to code it in the past...
The for_each_* macros are clearly not function calls but rather translate
to for () flow control constructs hence they should follow the same convention.
FWIW, I think that changing the existing convention is worth it in this case.

Benny

> - Arnaldo

