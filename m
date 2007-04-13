Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXDMKwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXDMKwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXDMKwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:52:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52519 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753306AbXDMKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:52:50 -0400
Date: Fri, 13 Apr 2007 11:55:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413115526.69e61016@the-village.bc.nu>
In-Reply-To: <461EF1A1.3070102@theshore.net>
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
	<p73ps697agf.fsf@bingen.suse.de>
	<461EE95A.3090600@theshore.net>
	<20070412193838.ea98238b.randy.dunlap@oracle.com>
	<461EF1A1.3070102@theshore.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I saw that too, and unfortunately I don't know what what that condition 
> represents, either.  It's the only other element in that if statement 
> that could make it take that path, so I'm assuming that's part of the 
> problem.

Multiple mm's mean multiple threads with a different set of mappings,
which would fit for UML. Either way there should be a check for !pipe
before appending the pid
