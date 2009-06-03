Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZFCGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZFCGiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZFCGiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:38:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZFCGiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:38:14 -0400
Date: Wed, 3 Jun 2009 08:38:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
Message-ID: <20090603063815.GE27563@wotan.suse.de>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-4-git-send-email-ebiederm@xmission.com> <20090602071411.GE31556@wotan.suse.de> <m1tz2ykzy5.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tz2ykzy5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:56:02PM -0700, Eric W. Biederman wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> >> In addition for a complete solution we need:
> >> - A reliable way the file structures that we need to revoke.
> >> - To wait for but not tamper with ongoing file creation and cleanup.
> >> - A guarantee that all with user space controlled duration are removed.
> >> 
> >> The file_hotplug_lock has a very unique implementation necessitated by
> >> the need to have no performance impact on existing code.  Classic locking
> >
> > Well, it isn't no performance impact. Function calls, branches, icache
> > and dcache...
> 
> Practically none.

OK that's different from none. There is obviously overhead.

