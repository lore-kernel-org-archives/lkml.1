Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbXDJNpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbXDJNpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 09:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXDJNpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 09:45:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50971 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbXDJNpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 09:45:00 -0400
Date: Tue, 10 Apr 2007 15:44:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andika Triwidada <andika@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: CPU offline but power consumption increased?
Message-ID: <20070410134458.GA723@one.firstfloor.org>
References: <7e0bae390704062123i2dfaf030icd5a710677bc989a@mail.gmail.com> <p73odlzkb6h.fsf@bingen.suse.de> <200704100413.51637.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704100413.51637.lenb@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Speaking for all Intel hardware implemented from pre-history until now,
> deep C-states is the best you can do, and there is no special offline
> mode to save more power.

We don't use deep c states currently; just HLT.

Right now it doesn't make much difference because no multi socket
servers do deep C states and secondary cores can normally not go
deep on their own; but if any of this changes this code would
need to be fixed.

But cpu off line is really a special case -- maybe it is even 
possible to do something better on current hardware.

> and if the BIOS is implemented properly, the core will be spinning in the
> deepest available C-state.  Of course, it would probably be more interesting
> to simply leave the core on-line and let it go idle...

I don't see any BIOS call in play_dead()

-Andi

