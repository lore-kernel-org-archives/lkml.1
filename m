Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbZDXEXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbZDXEXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZDXEXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:23:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55815 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZDXEXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:23:14 -0400
Date: Fri, 24 Apr 2009 05:20:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/2] do_execve() must not clear fs->in_exec if it was
 set by another thread
In-Reply-To: <20090423230156.GA31302@redhat.com>
Message-ID: <Pine.LNX.4.64.0904240519580.15735@blonde.anvils>
References: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
 <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk>
 <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
 <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
 <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
 <Pine.LNX.4.64.0904212031120.10256@blonde.anvils> <20090423230156.GA31302@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Hugh Dickins <hugh@veritas.com>
