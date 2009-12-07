Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZLGW0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZLGW0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZLGW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:26:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757744AbZLGW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:26:42 -0500
Date: Mon, 7 Dec 2009 14:26:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912071716080.15701-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912071426100.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071716080.15701-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Alan Stern wrote:
> 
> There's no need to suspend the individual devices when the whole system 
> is going down.  They will automatically suspend when the controller 
> stops sending out SOF packets, which occurs when the root hub is 
> suspended.  The USB spec describes this, grandiosely, as a "global 
> suspend".

Ahh, but the sync vs async would then still matter on resume. No?

		Linus
