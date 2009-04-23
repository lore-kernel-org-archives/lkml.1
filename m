Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZDWXdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZDWXdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZDWXda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:33:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZDWXd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:33:29 -0400
Date: Fri, 24 Apr 2009 00:31:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/2] do_execve() must not clear fs->in_exec if it was
	set by another thread
Message-ID: <20090423233157.GA22981@ZenIV.linux.org.uk>
References: <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain> <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain> <Pine.LNX.4.64.0904212031120.10256@blonde.anvils> <20090423230156.GA31302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423230156.GA31302@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 01:01:56AM +0200, Oleg Nesterov wrote:
> If do_execve() fails after check_unsafe_exec(), it clears fs->in_exec
> unconditionally. This is wrong if we race with our sub-thread which
> also does do_execve:


[snip]

Applied (both of those).
