Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbZEDBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbZEDBLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZEDBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 21:11:29 -0400
Received: from vena.lwn.net ([206.168.112.25]:54905 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZEDBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 21:11:28 -0400
Date: Sun, 3 May 2009 19:11:24 -0600
From: Jake Edge <jake@lwn.net>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: avoid leaking eip, esp, or wchan to
 non-privileged processes (fwd)
Message-ID: <20090503191124.27b3bf45@chukar>
In-Reply-To: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
References: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 09:27:29 +1000 (EST) James Morris wrote:
> This patch needs some review.

Indeed.

> Note that stable@kernel.org typically backport already-reviewed and 
> applied patches.  I think security@kernel.org is for reporting
> problems in a non-public way (whereas, this is already public
> knowledge).

I realize (now :) that I didn't get this out to all of the right folks,
thanks for doing that.  I didn't realize security@kernel.org was only
for non-public security problems, though.  Maybe there needs to be a
'security maintainer' separate from that list?  Or maybe there is one
and I just didn't find that person in MAINTAINERS?

It would seem that the 'start_stack' value output by /proc/pid/stat
should also only be available to processes that can ptrace ... that was
not part of my original patch, but I think should be added ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
