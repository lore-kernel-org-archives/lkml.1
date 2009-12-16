Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbZLPXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbZLPXHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZLPXHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:07:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbZLPXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:07:14 -0500
Date: Wed, 16 Dec 2009 23:07:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Vroon <tony@linx.net>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
Message-ID: <20091216230711.GN14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk> <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com> <1261004048.3154.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261004048.3154.2.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:54:08PM +0000, Tony Vroon wrote:
> On Thu, 2009-12-17 at 01:41 +0300, Alexander Beregalov wrote:
> > mkdir `/lib/rc/init.d/starting': Operation not supported
> 
> Confirmed, mkdir fails for any tmpfs filesystem. I can still create
> files using touch and remove them again with rm.

Hrm...  What about your CONFIG_TMPFS_POSIX_ACL?  And see if the breakage
starts at 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1 (make generic_acl slightly
more generic).
