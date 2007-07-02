Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXGBTI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXGBTI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXGBTIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:08:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbXGBTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:08:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: blink driver power saving
Date: Mon, 2 Jul 2007 21:08:43 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070701125035.3f54d8b0@oldman> <200707020159.51200.ak@suse.de> <20070702105000.73e50500@freepuppy.localdomain.hemminger.net>
In-Reply-To: <20070702105000.73e50500@freepuppy.localdomain.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707022108.43293.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 19:50:00 Stephen Hemminger wrote:

> The patch makes sense. You don't need to poll every jiffie to find
> out if system has panic.

The blink driver doesn't run on panic (or at least not on panic on
the same kernel). It runs always. It was designed to do the blinking
while the kdump kernel runs and writes the dump.

> But I agree with Linus, it is the kind 
> of patch that doesn't belong in the mainline kernel.  Every developer
> seems to have built up a set of crappy/fragile debug tools, but these
> don't belong in the wild.

Would you argue then that kdump also doesn't belong into the kernel?
The patch was designed to plug a hole in kdump (no visual feedback) 

-Andi
