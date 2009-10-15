Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbZJOGFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbZJOGFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbZJOGE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:04:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:35367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933759AbZJOGE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:57 -0400
Message-Id: <20091015044026.319860788@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:26 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/6] vfsmount scaling and other bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Finally got around to some numbers and a few comments with vfsmount scaling.
Patch looks a bit nicer now, and numbers aren't too bad I think.

I also broke the brlock stuff into its own header... it's a bit ugly but I
couldn't see a nice way to do the per-CPU stuff without adding indirection and
memory allocation of dynamic per-CPU allocations. Anyone like to yell at me
for this, or suggest a better approach?

I also put some other reasonable looking bits and pieces in there which have
filtered to the bottom of my vfs stack, as there are some clashes otherwise.
If you want me to stop sending them to you, could you merge them or tell me why
I'm an idiot, please?

Thanks,
Nick


