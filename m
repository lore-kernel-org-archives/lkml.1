Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZDWXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZDWXVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZDWXUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:20:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZDWXUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:20:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] do_execve() must not clear fs->in_exec if it was set
	by another thread
In-Reply-To: Oleg Nesterov's message of  Friday, 24 April 2009 01:01:56 +0200 <20090423230156.GA31302@redhat.com>
References: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
	<20090401023849.GW28946@ZenIV.linux.org.uk>
	<20090401030339.GX28946@ZenIV.linux.org.uk>
	<20090406153127.GA21220@redhat.com>
	<Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
	<20090421161006.GC5402@redhat.com>
	<alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
	<20090421171530.GA12014@redhat.com>
	<alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
	<Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
	<20090423230156.GA31302@redhat.com>
X-Zippy-Says: Yow!  We're going to a new disco!
Message-Id: <20090423231805.EF26EFC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 16:18:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
