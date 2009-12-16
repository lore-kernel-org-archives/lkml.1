Return-Path: <linux-kernel-owner+w=401wt.eu-S935921AbZLPX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935921AbZLPX1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935265AbZLPX1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:27:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57192 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935209AbZLPX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:27:34 -0500
Date: Wed, 16 Dec 2009 23:27:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Vroon <tony@vroon.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
Message-ID: <20091216232729.GO14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk> <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com> <1261004048.3154.2.camel@localhost> <20091216230711.GN14381@ZenIV.linux.org.uk> <1261005194.3154.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261005194.3154.4.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:13:14PM +0000, Tony Vroon wrote:
> On Wed, 2009-12-16 at 23:07 +0000, Al Viro wrote:
> > Hrm...  What about your CONFIG_TMPFS_POSIX_ACL?
> 
> That is off:
> chainsaw@prometheus /cvs/linux-2.6 $ zgrep -i tmpfs /proc/config.gz 
> # CONFIG_DEVTMPFS is not set
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> 
> >  And see if the breakage
> > starts at 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1 (make generic_acl slightly
> > more generic).
> 
> Do you want me to revert 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1
> locally or try linux-2.6 old enough not to have this?

The former.  Or try that kernel and compare with grandparent commit
(ef26ca97e83052790940cbc444b01b0d17a813c1)
