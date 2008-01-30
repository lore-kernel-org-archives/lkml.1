Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYA3Fz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYA3Fz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYA3Fzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:55:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbYA3Fzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:55:47 -0500
Date: Wed, 30 Jan 2008 16:54:36 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       auke-jan.h.kok@intel.com, jeff@garzik.org,
       "David S. Miller" <davem@davemloft.net>,
       akpm <akpm@linux-foundation.org>
Subject: Re: Mostly revert "e1000/e1000e: Move PCI-Express device IDs over
 to e1000e"
In-Reply-To: <alpine.LFD.1.00.0801301631400.3426@www.l.google.com>
Message-ID: <alpine.LFD.1.00.0801301653090.3426@www.l.google.com>
References: <200801292359.m0TNxb75011826@hera.kernel.org> <20080129212314.91b9bb5b.randy.dunlap@oracle.com> <alpine.LFD.1.00.0801301631400.3426@www.l.google.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jan 2008, Linus Torvalds wrote:
> 
> Untested, but as mentioned, this is more of a "this looks maintainable and 
> like it should solve the issues" rather than anything I was planning on 
> committing now.

Side note: I "verified" this patch by also diffing it against the HEAD^ 
state (before adding the PCIE ID's back in), to check that I marked 
exactly the right entries as PCIE() entries.

So while it's not tested, at least it looks right from two different 
angles ;)

			Linus
