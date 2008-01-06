Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYAFWMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYAFWMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYAFWL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:11:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2352 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754984AbYAFWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:11:52 -0500
Date: Sun, 6 Jan 2008 17:11:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801062005.12097.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801061710140.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:

> On Sunday, 6 of January 2008, Alan Stern wrote:

> Still, shouldn't we fail the removal of the device apart from giving the
> warning?

We can't.  device_del() can't fail -- it returns void.  Besides, how 
can a driver hope to deal with an unregistration failure?

Alan Stern

