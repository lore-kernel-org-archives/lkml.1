Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbXLTQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbXLTQ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXLTQ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:56:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:37586 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXLTQ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:56:01 -0500
Message-ID: <476A9E97.4040105@windriver.com>
Date: Thu, 20 Dec 2007 10:55:51 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2007 16:55:52.0338 (UTC) FILETIME=[2DEE6F20:01C84329]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
>
> - If something goes wrong with a PCI device's probing or initialisation, try
>   reverting pci-disable-decoding-during-sizing-of-bars.patch.
>
> - git-sched was dropped due to breaking suspend-to-RAM.
>
> - git-block has been restored after having had a few problems
>
> - git-newsetup.patch was dropped due to conflicts with git-x86
>
> - git-perfmon.patch is still dropped for the same reason
>
> - git-kgdb.patch is still dropped for the same reason
>
>   
Andrew,

I re-based the for_mm branch at:
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_mm
against the git-x86/mm branch from the x86-git tree. If there are other
patch trees I need to pull in and patch against to allow for kgdb to be
included into -mm please let me know.

I would like to submit another review request for kgdb into the mainline
as well as resolve the issues with the -mm tree + kgdb.

Thanks,
Jason.
