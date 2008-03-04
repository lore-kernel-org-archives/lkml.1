Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYCDNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYCDNnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYCDNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:43:28 -0500
Received: from openfortress.nl ([213.189.19.244]:39309 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751701AbYCDNn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:43:28 -0500
Date: Tue, 4 Mar 2008 13:43:22 +0000
From: Rick van Rein <rick@vanrein.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: devzero@web.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080304134322.GA19237@phantom.vanrein.org>
References: <182234194@web.de> <20080304132724.GB32383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304132724.GB32383@elte.hu>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

> as i said it in another reply to this thread, it would be perfectly 
> acceptable for upstream to merge an easier to use boot option - be that 
> badmem=addr$size or excludemem=addr$size.

I'm not sure if that is an optimal replacement of BadRAM at all.

Broken memories usually manifest themselves as a column or row in a DIMM
that stopped working.  So there is a pattern in the memory that is to be
excluded, and I'm not wholly sure that combines well with the excludemem
mechanism.  (I will look into it to be sure.)  I hope to know after the
weekend if the patterns that I am talking about can be turned into to a
cosmetic boot option.

I've also read that people on this list say that it is a waste to throw
out a full page if only 5 bytes (say) are actually faulty.  Although it
is certainly interesting from an academic viewpoint to avoid this, it has
never, ever led to complaints.  I've been advertising the possibility of
using the pages for allocation slabs, and allow all slabs except for those
with an error contained, but nobody has ever taken that seriously.

> Please send a patch :-)

I've been reluctant to quickly mend things because it could lead to
unstable code.  The patch that I am presenting is mature code, with the
possible exception of the somewhat newer 64-bit code.  If this list has
a preference for less mature code that is hardly field-tested, I could
of course tailor to that.


Cheers,

Rick van Rein
