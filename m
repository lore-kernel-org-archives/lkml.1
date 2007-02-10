Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXBJRRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXBJRRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXBJRRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:17:17 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59147 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXBJRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:17:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: Save the ipc namespace while reading proc files.
References: <m1veifrsly.fsf@ebiederm.dsl.xmission.com>
	<20070210162951.GA23777@vino.hallyn.com>
Date: Sat, 10 Feb 2007 10:16:48 -0700
In-Reply-To: <20070210162951.GA23777@vino.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 10 Feb 2007 10:29:51 -0600")
Message-ID: <m1r6sy0w73.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

>
> Looks good, thanks.
>
> Looks like mounts already does this with the mounts ns, and we don't
> need it for uts.  Something to watch in any upcoming network patches
> though.

Which is where I got the idea. :)

I did this so many times in my network namespace patches when I looked
at util.c it was blinding obvious...

Thanks for the review of the other obvious candidates.  I fixed this one
because I tripped over it, when fixing the ref counting bug.

Eric
