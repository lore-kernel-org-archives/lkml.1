Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbXJYXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbXJYXQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXJYXQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:16:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:36140 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXJYXQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:16:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 01:16:10 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260109.50092.ak@novell.com> <alpine.LFD.0.999.0710251613090.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710251613090.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260116.10904.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 01:14:41 Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Andi Kleen wrote:
> > > 
> > > Marking volatile I think is out of the question. To start with,
> > > volatile creates really poor code (and most of the time we actually
> > > do want the code in critical sections to be as tight as possible).
> > 
> > Poor code is better than broken code I would say.
> 
> No. A *working*compiler* is better than broken code.
> 
> There's no way to use volatile for these things, since it can hit 
> *anything*.

No it can't (at least not on x86) as I have explained in the rest of the mail 
you conveniently snipped.

-Andi
