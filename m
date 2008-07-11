Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYGKR6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYGKR6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYGKR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:58:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53004 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYGKR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:58:40 -0400
Date: Fri, 11 Jul 2008 19:59:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: rjw@sisk.pl, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix try_to_freeze_tasks()'s use of do_div()
Message-ID: <20080711175916.GA6261@elf.ucw.cz>
References: <20080711132146.31912.76254.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711132146.31912.76254.stgit@warthog.procyon.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-11 14:21:46, David Howells wrote:
> Fix try_to_freeze_tasks()'s use of do_div() on an s64 by making elapsed_csecs64
> a u64 instead and dividing that.
> 
> Possibly this should be guarded lest the interval calculation turn up negative,
> but the possible negativity of the result of the division is cast away anyway.
> 
> This was introduced by patch 438e2ce68dfd4af4cfcec2f873564fb921db4bb5.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
