Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYLFAvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYLFAvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYLFAv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:51:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbYLFAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:51:26 -0500
Date: Fri, 5 Dec 2008 16:50:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812060104.50050.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812051647130.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812052301.45450.rjw@sisk.pl> <alpine.LFD.2.00.0812051411400.3386@nehalem.linux-foundation.org> <200812060104.50050.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> I tested the appended patch with suspend-to-RAM and it just hangs during
> resume.

That patch looks bogus. It only changes the "legacy" cases as far as I can 
tell, so anybogy who has drv->pm set will now not do any state save at 
all.

Or am I misreading it?

		Linus
