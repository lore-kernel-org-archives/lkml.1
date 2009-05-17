Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZEQTQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZEQTQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZEQTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:16:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbZEQTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:16:35 -0400
Date: Sun, 17 May 2009 12:16:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Jeff Mahoney <jeffm@suse.com>
Subject: Re: [Bug #13122] reiserfs_delete_xattrs: Couldn't delete all xattrs
 (-13)
In-Reply-To: <385Pu-agh7M.A.sNC.mZzDKB@chimera>
Message-ID: <alpine.LFD.2.01.0905171213160.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.sNC.mZzDKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Rafael J. Wysocki wrote:
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13122
> Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-04-16 19:23 (31 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d984561b326cd0fe0d1183d11b9b4fa1d011d21d
> References	: http://marc.info/?l=linux-kernel&m=123990989515105&w=4
> Handled-By	: Jeff Mahoney <jeffm@suse.com>
> Patch		: http://lkml.org/lkml/2009/5/10/91

The fix should now be merged as b83674c0da6558e357c6b482ccf299eeea77d8ef 
("reiserfs: fixup perms when xattrs are disabled")

		Linus
