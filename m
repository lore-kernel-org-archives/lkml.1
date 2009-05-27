Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbZE0Pnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbZE0Pnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbZE0Pnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:43:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758981AbZE0Pna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:43:30 -0400
Date: Wed, 27 May 2009 08:34:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
In-Reply-To: <1243409850-21577-18-git-send-email-jeremy@goop.org>
Message-ID: <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 May 2009, Jeremy Fitzhardinge wrote:
> 
> [ Impact: prevent MSI subsystem from crashing ]

Grr.

I looked at several of these impact lines, and they were _all_ totally 
misleading.

Please, guys. Stop with the F*CKING impact lines already. Add them if they 
are obvious, but don't make them this idiotic "do an impact line whether 
or not it makes sense".

I hate them. They are stupid. 90% of all the impact lines I see are either 
(a) misleading or (b) totally inane and pointless. 

In this case, we would have been a LOT BETTER OFF with having just a 
better header line that said "xen: disable MSI to avoid crash" or 
something like that. But no. THAT F*CKING IMPACT LINE apparently meant 
that Jeremy just turned off his brain, and made _both_ the header line and 
the Impact: line be non-descriptive.

Really. Stop it. Ingo, start saying "no" to people, at least for impact 
lines that do not make sense. It adds _nothing_, and it actually detracts 
from real content, because just the inanity of them delutes the whole 
meaning of it.

		Linus
