Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbYCDOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbYCDOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763976AbYCDOGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:06:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763964AbYCDOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:06:14 -0500
Date: Tue, 4 Mar 2008 15:06:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rick van Rein <rick@vanrein.org>
Cc: devzero@web.de, pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080304140604.GG32383@elte.hu>
References: <182234194@web.de> <20080304132724.GB32383@elte.hu> <20080304134322.GA19237@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304134322.GA19237@phantom.vanrein.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rick van Rein <rick@vanrein.org> wrote:

> > as i said it in another reply to this thread, it would be perfectly 
> > acceptable for upstream to merge an easier to use boot option - be 
> > that badmem=addr$size or excludemem=addr$size.
> 
> I'm not sure if that is an optimal replacement of BadRAM at all.
> 
> Broken memories usually manifest themselves as a column or row in a 
> DIMM that stopped working.  So there is a pattern in the memory that 
> is to be excluded, and I'm not wholly sure that combines well with the 
> excludemem mechanism.  (I will look into it to be sure.)  I hope to 
> know after the weekend if the patterns that I am talking about can be 
> turned into to a cosmetic boot option.

feel free to extend the "excludemem=" mechanism to support the full 
range of "badram=" configuration methods. As long as you are able to 
feed it into an e820 table (which is not trivial at all), it's the right 
thing to do and it would be mainstream acceptable.

and i wouldnt mind the "badmem=" option either - because you already 
have users of that facility and it's intuitively named as well - as long 
as it's cleanly fed into the e820 space. I.e. it would all look and 
behave the same way towards users as the BadMem patch does - with a 
different internal approach.

	Ingo
