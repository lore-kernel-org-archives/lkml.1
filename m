Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZDKT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZDKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZDKT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:59:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519AbZDKT7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:59:05 -0400
Date: Sat, 11 Apr 2009 12:55:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@suse.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       linux-pm@lists.linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
In-Reply-To: <200904112138.26518.rjw@suse.com>
Message-ID: <alpine.LFD.2.00.0904111253520.4583@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain> <49DFFC05.7070509@linux.intel.com> <200904112138.26518.rjw@suse.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Rafael J. Wysocki wrote:
> 
> FWIW, I applied the appended patch and it fixed the problem for me.

I think that patch is probably the right thing to do regardless, but I 
also think it doesn't obviate the need for also doing so at module loading 
time. 

I'm pretty sure that calling scsi_complete_async_scans() won't protect 
against an async USB bus scan, for example.

But I do think your patch is probably worth doing anyway.

		Linus
