Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZDKQ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZDKQ5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZDKQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:56:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37820 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZDKQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:56:58 -0400
Date: Sat, 11 Apr 2009 17:56:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
Message-ID: <20090411165651.GW26366@ZenIV.linux.org.uk>
References: <m1skkf761y.fsf@fess.ebiederm.org> <20090411155852.GV26366@ZenIV.linux.org.uk> <m1k55ryw2n.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k55ryw2n.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 09:49:36AM -0700, Eric W. Biederman wrote:

> The fact that in the common case only one task ever accesses a struct
> file leaves a lot of room for optimization.

I'm not at all sure that it's a good assumption; even leaving aside e.g.
several tasks sharing stdout/stderr, a bunch of datagrams coming out of
several threads over the same socket is quite possible.
