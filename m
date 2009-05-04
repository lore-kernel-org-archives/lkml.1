Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZEDQLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZEDQLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZEDQLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:11:13 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:32867 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZEDQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i32VvwMliINfDQ0sIe9/omFfxnQkhBCx3K0bTMjLTaWLlWgQYNmilWenK9Lyy84AL8
         VOLtsqcpzZN8be+NfqEONuJ+OIM1jWOtm54fQNnmvxJ8kwhSje/SY+ZDr1ZTC63JZRsG
         jyV+/5z2laMZC1b3ChxJB+y79yAn/w4gg4/og=
Date: Mon, 4 May 2009 20:11:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504161109.GQ4173@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo> <alpine.DEB.1.10.0905041011200.17937@qirst.com> <20090504142903.GM4173@lenovo> <20090504152026.GO4173@lenovo> <alpine.DEB.1.10.0905041148490.10044@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905041148490.10044@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Mon, May 04, 2009 at 11:54:53AM -0400]
| On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| 
| > You know I only found a message in case if page is already
| > not granted (ie NULL is going to be returned) and right
| > before that we print a warning about that (nopage: label).
| > Which means - no panic here and with (__GFP_NOFAIL | __GFP_REPEAT)
| > just spinning around in attepmt to allocate new memory. And how
| > to behave on atomic allocations. Almost give up... :)
| 
| Could you check for __GFP_FAIL|__GFP_REPEAT somewheres and panic? Not sure
| if __GFP_REPEAT is the right second flag to use.
| 

OK, I thought about various mods combinations too. Will recheck
if there a way more precise. Thanks!

	-- Cyrill
