Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXGZX2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXGZX2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXGZX16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:27:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52845 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXGZX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:27:57 -0400
Message-ID: <46A92DF4.6000301@garzik.org>
Date: Thu, 26 Jul 2007 19:27:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Dirk Schoebel <dirk@liji-und-dirk.de>
CC: ck@vds.kolivas.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>,
       Eric St-Laurent <ericstl34@sympatico.ca>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070726111326.873f7b0a.akpm@linux-foundation.org> <200707270004.46211.dirk@liji-und-dirk.de> <200707270033.41055.dirk@liji-und-dirk.de>
In-Reply-To: <200707270033.41055.dirk@liji-und-dirk.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Schoebel wrote:
> as long as the 
> maintainer follows the kernel development things can be left in, if the 
> maintainer can't follow anymore they are taken out quite fast again. (This 
> statement mostly counts for parts of the kernel where a choice is possible or 
> the coding overhead of making such choice possible is quite low.)


This is just not good engineering.

It is axiomatic that it is easy to add code, but difficult to remove 
code.  It takes -years- to remove code that no one uses.  Long after the 
maintainer disappears, the users (and bug reports!) remain.

It is also axiomatic that adding code, particularly core code, often 
exponentially increases complexity.

	Jeff


