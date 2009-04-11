Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZDKT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZDKT5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZDKT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:57:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZDKT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:57:27 -0400
Date: Sat, 11 Apr 2009 12:50:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Heinz Diehl <htd@fancy-poultry.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
In-Reply-To: <49E0EC87.9080808@linux.intel.com>
Message-ID: <alpine.LFD.2.00.0904111247320.4583@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain> <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
 <49E0EC87.9080808@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Arjan van de Ven wrote:
>
> Now that I've been able to scan most of my mail; it looks like the one-liner
> should just go in.

Ok, I committed my one-liner, and then also reverted the ACPI battery 
workaround of removing __init, since the one-liner should fix that too.

Cc'ing the people involved with that commit, just so that they know to 
test to make sure the alternate fix really did fix it for them (I'm pretty 
sure it does, but still a good idea to verify or at least let people know 
that a previous fix got reverted)

			Linus
