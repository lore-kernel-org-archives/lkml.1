Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZLICyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZLICyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZLICyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:54:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbZLICyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:54:51 -0500
Date: Tue, 8 Dec 2009 18:54:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912082125410.26994-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.0912081852320.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912082125410.26994-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
> 
> You mean, if A comes before B in the list and A must suspend after B?  

But if they are not topologically ordered, then A wouldn't necessarily be 
before B on the list in the first place.

Of course, if we've mucked with the list by hand and made sure the 
ordering is ok, then that's a different issue. But your whole point seemed 
to be that the device could impose its own ordering in its suspend 
callback, which is not true on its own without external ordering.

		Linus
