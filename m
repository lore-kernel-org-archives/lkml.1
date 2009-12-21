Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZLUXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZLUXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZLUXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:01:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbZLUXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:01:03 -0500
Date: Mon, 21 Dec 2009 15:00:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC] Asynchronous suspend/resume - test results
In-Reply-To: <200912212136.12665.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912211456320.21722@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org> <200912212136.12665.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:
> 
> Do you think it's a good idea to mark all SCSI devices as async?  Well, for
> testing it probably is, but I doubt in general.

As long as things aren't multi-path, or multi-lun, it's probably fine.

With multi-path (ie same disk reachable multiple ways), it's probably fine 
too, but let's face it, who the hell knows? But it's not going to be an 
issue for laptops and normal desktops.

For multi-lun, I suspect the luns are related, and there might be some 
ordering issues. But it's _likely_ all fine there too.

The nice thing about systems with wires (ie USB, SCSI, SATA) is that it's 
really hard to make different devices have odd dependencies on each other. 
The wires tend to _be_ the topology.

			Linus
