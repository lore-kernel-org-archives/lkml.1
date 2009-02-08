Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZBHWEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZBHWEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZBHV4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:56:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117AbZBHV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:56:01 -0500
Date: Sun, 8 Feb 2009 13:55:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-rc4: Reported regressions from 2.6.28
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
Message-ID: <alpine.LFD.2.00.0902081354150.3048@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12669
> Subject		: 2.6.28.4 regression: mmap fails if mlockall used
> Submitter	: Sami Farin <safari-kernel@safari.iki.fi>
> Date		: 2009-02-08 10:52 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=123409037423068&w=4

Oh, Hugh just sent a patch, and it's now commit 
d5b562330ec766292a3ac54ae5e0673610bd5b3d. Sadly this just missed -rc4 by 
something like 20 minutes..

		Linus
