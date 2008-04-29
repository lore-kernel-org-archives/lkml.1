Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYD2WWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYD2WWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYD2WV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:21:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47125 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYD2WV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:21:58 -0400
Date: Tue, 29 Apr 2008 16:21:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, willy@debian.org,
       viro@zeniv.linux.org.uk, uclinux-dist-devel@blackfin.uclinux.org,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080429222141.GD14976@parisc-linux.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429135454.efebec8f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:54:54PM -0700, Andrew Morton wrote:
> I guess we should make the generic_setlease() heuristic smarter.
> 
> Of course the _reason_ for that heuristic is uncommented and lost in time. 
> And one wonders what locking prevents it from being totally racy, and if
> "none", what happens when the race hits.  Sigh.

It's hardly "lost in time" when you can ask the original author.

If there are multiple processes with this file open, you can't place a
lease on it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
