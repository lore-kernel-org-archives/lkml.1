Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZLKNEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZLKNEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZLKNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:04:25 -0500
Received: from mail2.picochip.com ([82.111.145.34]:42747 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbZLKNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:04:25 -0500
Date: Fri, 11 Dec 2009 13:04:08 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, jamie.iles@picochip.com, mikpe@it.uu.se,
       linux@arm.linux.org.uk, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools: Allow building for ARM
Message-ID: <20091211130408.GG4164@wear.picochip.com>
References: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com> <tip-58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 13:02:54 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:54:33PM +0000, tip-bot for Jamie Iles wrote:
> Commit-ID:  58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
> Gitweb:     http://git.kernel.org/tip/58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
> Author:     Jamie Iles <jamie.iles@picochip.com>
> AuthorDate: Fri, 11 Dec 2009 12:20:09 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 11 Dec 2009 13:50:21 +0100
> 
> perf tools: Allow building for ARM
> 
> Add definitions of rmb() and cpu_relax() and include the ARM
> unistd.h header. The __kuser_memory_barrier helper in the helper
> page is used to provide the correct memory barrier depending on
> the CPU type.
> 
> [ The rmb() will work on v6 and v7, segfault on v5. Dynamic
>   detection to add v5 support will be added later. ]
Sorry Ingo, my comment probably wasn't clear enough. The helper that Mikael
suggested should work for _all_ ARM processors including v5 and earlier. It
will just be a branch to a nop.

Jamie
