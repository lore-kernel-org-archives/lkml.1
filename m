Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZDXHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZDXHTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZDXHS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:18:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46835 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZDXHS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:18:56 -0400
Date: Fri, 24 Apr 2009 08:18:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424071853.GG8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424071312.GE8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 08:13:12AM +0100, Al Viro wrote:

> AFAICS, both CIFS_SB(sb) and ->tcon are assign-once, so lock_kernel() should
> really go here (if it can't be removed completely, of course, but that's up
> to CIFS folks).  Applied with such modification.

commit 208f6be8f9244f4a3e8de7b4c6ca97069698303a in
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/

if you want to see the version after that change (or wait for linux-next
to pick it).
