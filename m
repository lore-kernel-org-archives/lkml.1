Return-Path: <linux-kernel-owner+w=401wt.eu-S1763418AbYEBH4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418AbYEBH4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYEBH4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:56:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYEBH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:56:33 -0400
Date: Fri, 2 May 2008 10:03:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: Why such a big difference in init-time PCI resource call-paths (x86 vs x86_64) ?
Message-ID: <20080502080303.GQ20451@one.firstfloor.org>
References: <fa.GFIas4KVpQq9pUpviRWeT8L+oBs@ifi.uio.no> <fa.hdrruKIvW+GZA0AESo+nBXNURSA@ifi.uio.no> <fa.9Qhgua9PuRzPYMHNs+ZG5Q7/Hbg@ifi.uio.no> <fa.sQSbKD/rf/mnDK28NkngvUl4UA8@ifi.uio.no> <481AA095.3010201@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481AA095.3010201@shaw.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI, from what I've read, Windows ignores e820 for detecting resource 
> reservations and looks at ACPI reservations only (at least if it's 
> running in ACPI mode which these days is almost universal). It seems 
> Windows really only uses e820 for locating RAM areas..

The usual problem is that they don't use that on older systems
but a different HAL (or XP doesn't run at all on these older systems).
But Linux still wants to run on older systems, ideally without
special settings too.

So if it's done like this it likely needs some date or other heuristic to 
decide if it should trust ACPI or should not. 

-Andi
