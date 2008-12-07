Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYLGGEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYLGGEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 01:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYLGGEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 01:04:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbYLGGEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 01:04:24 -0500
Date: Sat, 6 Dec 2008 22:03:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
In-Reply-To: <alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812062201230.3425@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org> <200812062236.44111.rjw@sisk.pl> <alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org> <20081206152545.326c8b67@infradead.org>
 <alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Linus Torvalds wrote:
> 
> And btw, I'm talking suspend, not hibernate. 

And, btw, even if anybody actually does this, it should be up to the 
interrupt controller logic to re-initialize the interrupts so that they 
are back where they belong. IOW, we should never show such _idiotic_ 
brokenness to any actual driver, it should all be remapped and handled 
below them.

And I still have never heard any valid reason to do it in the first place, 
so until somebody actually gives a real example and an explanation, I 
would suggest ignoring the whole issue as some insane rumblings from crazy 
hw/firmare people doing idiotic things.

			Linus
