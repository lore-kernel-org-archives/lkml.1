Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZDWXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZDWXVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZDWXUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZDWXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:20:53 -0400
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
Subject: Re: [PATCH 2/2] check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/
In-Reply-To: Oleg Nesterov's message of  Friday, 24 April 2009 01:02:45 +0200 <20090423230245.GB31302@redhat.com>
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
	<20090423230245.GB31302@redhat.com>
X-Windows: more than enough rope.
Message-Id: <20090423231815.43D9FFC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 16:18:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
