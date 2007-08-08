Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbXHHOcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbXHHOcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbXHHObz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:31:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:45767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXHHObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:31:53 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Add ability to print calltraces tighter on i386
References: <46B9D08F.8080402@openvz.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 17:26:13 +0200
In-Reply-To: <46B9D08F.8080402@openvz.org>
Message-ID: <p73zm12qc8a.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> When printing a BUG or OOPS report the longest part of it is
> the calltrace, which sometimes (quite often) doesn't fit the
> standard 25-lines display. This may become a bad news when the
> system doesn't have a serial/net console and is completely frozen so
> that the terminal scrolling doesn't work.
> 
> The information that hides from the developer is registers, the
> top of the calltrace and information about the kernel and the
> crashed process (uname). As our experience shows, seeing this info is
> sometimes critical and having a short calltrace would help a lot.
> 
> The proposal is to make a boot-option called "tight_trace", that
> makes the calltrace show only the addresses in one line instead
> of the symbol names one per line.
> 
> E.g. OOPSes of 50 lines occupy ~20 with this patch.
> 
> This is an example of how it will look for i386, but if this
> will be found useful, I will make the patch for other arched
> I can test it on (at least x86_64, ia64).

Just use a higher resolution with vga=... 
I have yet to see an oops that doesn't fit on 80x50

-Andi
