Return-Path: <linux-kernel-owner+w=401wt.eu-S966495AbYD1Scv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966495AbYD1Scv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937032AbYD1S2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:28:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52268 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936822AbYD1S2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:28:00 -0400
Date: Mon, 28 Apr 2008 19:27:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: umount(/proc) after CLONE_NEWNS in 2.6.25?
Message-ID: <20080428182759.GF5882@ZenIV.linux.org.uk>
References: <481609A5.1080905@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481609A5.1080905@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:30:13PM +0400, Michael Tokarev wrote:
> [pid 6308] clone(child_stack=0xbfc9de94, flags=CLONE_NEWNS|SIGCHLD) = 6309
> [pid  6309] execve("/usr/sbin/umount", ["umount", "-n", "/proc"])
> ...
> [pid  6309] oldumount("/proc")          = -1 EBUSY (Device or resource busy)
> umount: /proc: device is busy
>
> Yes, various NAMESPACEs are enabled (i'm trying to experiment with
> those).
>
> Is it intentional?

It's very odd.  Could you bisect that down to offending changeset or
at least narrow the things down to -rc<something>?  I'm going down right
now, so won't be able to look into that until tonight...
