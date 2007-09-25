Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbXIYALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbXIYALD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbXIYAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:10:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1744 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546AbXIYAKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:10:52 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: holzheu@linux.vnet.ibm.com, Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <200709241851.59611.rob@landley.net>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
	 <1190647156.30132.92.camel@localhost>  <200709241851.59611.rob@landley.net>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 17:10:32 -0700
Message-Id: <1190679032.636.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 18:51 -0500, Rob Landley wrote:
> > An added pass between gcc preprocessor and compiler could compact
> > or compress the format string without modifying the conversion
> > specifications so __attribute__ ((format (printf)) would still work.
> This does not address my problem.  Spitting out a proprietary hash code 
> instead of a human readable message is not a solution for my use case.

What is your problem Rob?

I think message numbers are difficult to produce from format strings.
I think kernel version/file/func/line is enough to identify messages
for normal use but not too useful for embedded.

I think losslessly compressing, not hashing, the format string
would be useful.  The format string would be expanded by printk.
The kernel size would be smaller and more easily fit in minimal RAM.
Losslessly compressing the format strings probably won't reduce
flash image size.

cheers, Joe

