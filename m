Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXGFSXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXGFSXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbXGFSXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:23:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:64307 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbXGFSXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:23:42 -0400
Message-ID: <468E88CE.2060809@windriver.com>
Date: Fri, 06 Jul 2007 13:24:14 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: preemption counter havoc on kgdb-taken faults
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<468E4BA5.8010601@imap.cc> <468E8106.8080801@windriver.com> <468E86DF.4050509@web.de>
In-Reply-To: <468E86DF.4050509@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2007 18:23:22.0971 (UTC) FILETIME=[BC9132B0:01C7BFFA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
>
> At this chance... Reminds me that this old issue still seems to be
> unsolved in current kgdb:
>
> http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg00442.html
>
> I'm only looking at that spot in kgdb right now and /may/ oversee new
> border conditions elsewhere. But my feeling is there are none.
>
> Jan (looking forward to see kgdb merged)
>
>   


Hi Jan,

This issue was fixed in a generic way in the patch set that is in the 
-mm tree.  Had you tried your test case in the current -mm tree?

The problem you mentioned was fixed by saving and restoring the preempt 
count as a part of the fault handling from the kgdb core and not in the 
arch specific portion.

Jason.
