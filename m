Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZBCD0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZBCD0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZBCDZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:25:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbZBCDZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:25:55 -0500
Date: Mon, 2 Feb 2009 19:25:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] PCI PM: More refinements of suspend-resume
 framework
In-Reply-To: <200902021032.26819.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0902021924270.3247@localhost.localdomain>
References: <200902012229.27517.rjw@sisk.pl> <200902021032.26819.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Jesse Barnes wrote:
> >
> > The last patch makes the warning in pci_legacy_suspend() more useful.
> 
> Linus, do you want these as part of the next pull request?  If so, I'll check 
> them out, pull them in, and let them run the linux-next build gauntlet for a 
> day before sending them.  Otherwise I'll just send a pull request today with 
> the 8 or so fixes I have queued now.

I want them eventually, but I don't know if we got confirmation that this 
particular series actually fixed the PCI-E bridge issue? The one that 
Parag reported.. It would be good to have confirmation. Maybe we do 
already and I missed that email?

		Linus
