Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZBILEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZBILEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZBILDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:03:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZBILDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:03:53 -0500
Date: Mon, 9 Feb 2009 11:03:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       containers@lists.osdl.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090209110348.GV28946@ZenIV.linux.org.uk>
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org> <498FEE24.5030407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498FEE24.5030407@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	BTW, a trivial note - kfree(root) in your ->kill_sb() is done
earlier than it's nice to do.  Shouldn't affect the problem, though.
