Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZE0WQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZE0WQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762001AbZE0WPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:15:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761833AbZE0WP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:15:29 -0400
Date: Wed, 27 May 2009 15:13:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
In-Reply-To: <adavdnm5hkx.fsf@cisco.com>
Message-ID: <alpine.LFD.2.01.0905271511440.3435@localhost.localdomain>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527211828.GA6166@elte.hu> <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
 <adavdnm5hkx.fsf@cisco.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 May 2009, Roland Dreier wrote:
> 
> I could see adding a tag along the lines of tested-by, reported-by,
> reviewed-by, etc.  Maybe something like
> 
>     Closes-bug: <URL>

I agree that that would work, but that way also lies endless other tags. 
People seem to always want to have some magic tag to grep for, if we can 
make 'impact:' be it rather than have potentially lots of random ones, 
maybe impact: is simply better?

		Linus
