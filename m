Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759525AbYLQJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYLQJK3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYLQJKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:10:09 -0500
Received: from eazy.amigager.de ([213.239.192.238]:54165 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYLQJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:10:08 -0500
Date: Wed, 17 Dec 2008 10:10:03 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Theodore Tso <tytso@mit.edu>
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217091003.GA26609@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
References: <20081217001625.GA3250@x61> <20081217005210.GA889@dose.home.local> <20081217032517.GE10590@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217032517.GE10590@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 22:25:17 -0500, Theodore Tso wrote:

[...]

> I *thought* mutt had a patch which sorted the files returned by
> readdir() by inode number, and then opened the files sorted by inode
> number order; maybe it was a distro-specific patch that was never
> pushed back to mainline, though.  In any case, sorting list of

It is in mutt upstream, and enabled by default, but only if
maildir_header_cache_verify is set. If not, the inode list is kept
unsorted. maildir_header_cache_verify is enabled by default, but I
disabled it in my muttrc.

Regards,
Tino
