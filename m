Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXEZOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXEZOF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXEZOFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:05:21 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49740 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXEZOFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:05:21 -0400
Date: Sat, 26 May 2007 07:03:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <ak@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix oprofile double free (was Re: Multiple free
	during oprofile unload)
Message-ID: <20070526140313.GP3429@sequoia.sous-sol.org>
References: <4656FA04.5000403@redhat.com> <20070525193737.34609de2@the-village.bc.nu> <20070526022741.GD3390@sequoia.sous-sol.org> <200705260943.21541.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705260943.21541.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> 
> > And, in this case we're in luck.  It's not released in any -stable tree
> > yet (it's queued for the next release).  So there's plenty of time to
> > fix it up before next -stable release.
> > 
> > Something like below should fix it.
> 
> I already got a similar patch, but not tested yet.

OK.  I tested the one I sent, on Opteron.
