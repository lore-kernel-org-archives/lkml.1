Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0BOWfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:35:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0BOWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:35:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=R/IaVkKkF+s29lHgL4lkhPc5xuEHUwqzylAit50v0IRyILeljpGBj4Ar4uZ2eoSFz
	F1Q9kq6awEEL1W4MxfX4w==
Date: Mon, 15 Feb 2010 14:35:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 6/9 v2] oom: deprecate oom_adj tunable
In-Reply-To: <20100215222845.0b0f2781@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1002151433040.1324@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418560.26927@chino.kir.corp.google.com> <20100215222845.0b0f2781@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, Alan Cox wrote:

> > /proc/pid/oom_adj is now deprecated so that that it may eventually be
> > removed.  The target date for removal is December 2011.
> 
> There are systems that rely on this feature. It's ABI, its sacred. We are
> committed to it and it has users. That doesn't really detract from the
> good/bad of the rest of the proposal, it's just one step we can't quite
> make.
> 

Andrew suggested that it be deprecated in this way, so that's what was 
done.  I don't have any strong opinions about leaving it around forever 
now that it's otherwise unused beyond simply converting itself into units 
for /proc/pid/oom_score_adj at a much higher granularity.
