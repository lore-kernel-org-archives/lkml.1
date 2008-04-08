Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYDHO5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYDHO5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYDHO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:56:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:60065 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYDHO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:56:55 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       NetDev <netdev@vger.kernel.org>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <greg@kroah.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices
From: Andi Kleen <andi@firstfloor.org>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu>
Date: Tue, 08 Apr 2008 16:56:52 +0200
In-Reply-To: <20080408083606.GA20863@elte.hu> (Ingo Molnar's message of "Tue, 8 Apr 2008 10:36:06 +0200")
Message-ID: <87iqyspf7v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2008 14:50:10.0103 (UTC) FILETIME=[D7D93470:01C89987]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> ( sidenote: isnt there some facility that selects the "better" driver in 
>   case there is an overlap between PCI IDs - with the ability for users 
>   to override that selection? )

The default action for driver auto loaders in this case is usually to load
all of them unless specially overriden. That is because there are several
cases where one PCI-ID implements multiple functions served by different
drivers. So far there is no really clean solution to this problem and for
e1000 with PCI-E IDs it would do the wrong thing.

-Andi
