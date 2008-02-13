Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbYBMFSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbYBMFSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYBMFRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:17:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:28167 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYBMFRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:17:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 13 Feb 2008 00:17:52 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-reply-to: <alpine.LFD.1.00.0802121936450.2920@woody.linux-foundation.org>
Message-id: <alpine.LFD.1.00.0802130014560.2732@xanadu.home>
References: <47B1CB08.4020101@garzik.org>
 <20080212.155853.193190548.davem@davemloft.net>
 <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>
 <20080212.172051.58554658.davem@davemloft.net>
 <1202869550.3137.182.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org>
 <1202871616.3137.197.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
 <alpine.LFD.1.00.0802121936450.2920@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Linus Torvalds wrote:

> Of course, if you didn't even want to save the old branch, just skip the 
> first step. If you have reflogs enabled (and git does that by default in 
> any half-way recent version), you can always find it again, even without 
> having to do "git fsck --lost-found", at least as long as you don't delete 
> that branch, and it hasn't gotten pruned away (kept around for the next 90 
> days by default, iirc)

Even if you delete that branch, the "HEAD" reflog will still contain it, 
since it is separate from any particular branch reflog.


Nicolas
