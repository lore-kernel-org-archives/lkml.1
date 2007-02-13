Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbXBMLH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbXBMLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXBMLH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:07:57 -0500
Received: from ns.firmix.at ([62.141.48.66]:38134 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXBMLH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:07:56 -0500
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
	to "array_for_each(index, array)"
From: Bernd Petrovitsch <bernd@firmix.at>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Joe Perches <joe@perches.com>, Ben Nizette <ben.nizette@iinet.net.au>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45D198DB.3040006@yahoo.com.au>
References: <1171324070.1528.25.camel@localhost>
	 <45D10460.6000903@iinet.net.au> <1171327648.1528.30.camel@localhost>
	 <45D13C34.2040400@yahoo.com.au> <1171352052.1528.48.camel@localhost>
	 <45D16BF8.9090409@yahoo.com.au> <1171362988.21261.12.camel@tara.firmix.at>
	 <45D198DB.3040006@yahoo.com.au>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 13 Feb 2007 12:07:48 +0100
Message-Id: <1171364868.21261.20.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.415 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.415 required=5
X-Spam-Score: -2.415 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 21:54 +1100, Nick Piggin wrote:
> Bernd Petrovitsch wrote:
> > On Tue, 2007-02-13 at 18:42 +1100, Nick Piggin wrote:
> > 
> >>Joe Perches wrote:
> > 
> > [...]
> > 
> >>>perhaps:
> >>>
> >>>#define array_for_each(element, array) \
> >>>	for ((element) = (array); \
> >>>	     (element) < ((array) + ARRAY_SIZE((array))); \
> >>>	     (element)++)
> >>
> >>If you're going for consistency, then shouldn't this be
> >>array_for_each_entry()?
> > 
> > 
> > That depends on the decision between consistency to array_for_each_index
> > or consistency to list_for_each.
> 
> I don't follow.

Yes, thinko on my side. Sorry.

> list_for_each gives you a list_head.
> list_for_each_entry gives you a pointer to an entry in the list, which
> is equivalent to the above loop which gives a pointer to an entry in the
> array. Accordingly, it should be called array_for_each_entry. What sort
> of logic leads to another conclusion?

The wrong logic that list_for_each gives an entry. Sorry f.t. confusion.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

