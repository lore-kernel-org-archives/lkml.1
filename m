Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbXIXXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbXIXXwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbXIXXwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:52:05 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57127
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758509AbXIXXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:52:04 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Joe Perches <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Mon, 24 Sep 2007 18:51:59 -0500
User-Agent: KMail/1.9.6
Cc: holzheu@linux.vnet.ibm.com, Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dick Streefland <dick.streefland@altium.nl>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> <1190625742.12666.30.camel@localhost.localdomain> <1190647156.30132.92.camel@localhost>
In-Reply-To: <1190647156.30132.92.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241851.59611.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 10:19:16 am Joe Perches wrote:
> On Mon, 2007-09-24 at 11:22 +0200, Michael Holzheu wrote:
> > Together with the idea of not allowing multiple lines in the kprint_xxx
> > functions, that would go with our approach having message numbers to
> > identify a message.
>
> How does this equate/give message numbers?

I actively want to avoid giving message numbers.  My interest is in 
selectively removing messages from the kernel to shrink the binary size (and 
NOT make it up in either a larger userspace utility to translate them, or 
else magic proprietary numbers you can only diagnose if you pay my support 
staff).

> An added pass between gcc preprocessor and compiler could compact
> or compress the format string without modifying the conversion
> specifications so __attribute__ ((format (printf)) would still work.

This does not address my problem.  Spitting out a proprietary hash code 
instead of a human readable message is not a solution for my use case.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
