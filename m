Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZC2EPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZC2EPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZC2EPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:15:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36851 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZC2EPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:15:20 -0400
Date: Sun, 29 Mar 2009 05:14:12 +0100
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
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090329041412.GG28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329041022.GF28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 05:10:22AM +0100, Al Viro wrote:

> Frankly, I don't think we really care.  Note that having several sub-threads
> and doing execve() in one of them will kill the rest, so you really want
> to do some kind of synchronization

in userland, that is

> to get something similar to reasonable
> behaviour anyway.
