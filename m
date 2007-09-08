Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXIHKT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXIHKT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXIHKTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:19:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:60584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXIHKTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:19:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 12:19:43 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709081053.36842.ak@suse.de> <200709080557.36021.nickpiggin@yahoo.com.au>
In-Reply-To: <200709080557.36021.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081219.43662.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007 21:57:35 Nick Piggin wrote:

> 
> > > Anyway, the lfence should be able to go away without so much trouble.
> >
> > You mean sfence? lfence in rmb is definitely needed.
> 
> I mean lfence in smp_rmb().

One point of rmb is to stop speculative loads and I don't think we 
can get that without lfence.

-Andi

