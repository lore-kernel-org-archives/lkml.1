Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXJ3Wsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXJ3Wsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXJ3WsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:48:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbXJ3WsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:48:24 -0400
Date: Tue, 30 Oct 2007 15:48:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <200710301531.58957.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.999.0710301546530.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710301504.36972.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
 <200710301531.58957.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Jesse Barnes wrote:
> 
> Yeah, that's definitely a problem, and would be a firmware bug.  There's 
> no doubt that firmwares have had trouble with this in the past, but 
> given that Vista now relies on this stuff working, it's a lot more 
> likely to be reliable in current and future systems.

I agree. I think most of the big problems we had were basically with 
unreleased or very early systems.

But the per-device flag should "just fix it" regardless, and we can go 
forward assuming that things work, but without breaking those borderline 
systems.

			Linus
