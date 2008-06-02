Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYFBMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYFBMtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYFBMtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:49:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54286 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYFBMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:49:08 -0400
Date: Mon, 2 Jun 2008 06:49:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602124906.GD8562@parisc-linux.org>
References: <20080529134903.615127628@szeredi.hu> <E1K38aL-0003KY-Qq@pomaz-ex.szeredi.hu> <20080602123244.GC8562@parisc-linux.org> <200806021445.13831.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806021445.13831.agruen@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 02:45:10PM +0200, Andreas Gruenbacher wrote:
> Without the vfsmount, when something is mounted in more than once place, you 
> cannot report which of the name aliases a process is accessing. This is 
> unacceptable; the logs would become unusable. With pathname-based, the 
> AppArmor and TOMOYO folks really mean pathname-based, not a hybrid pathname / 
> mount point model.

audit_getname manages to do this.  You're just not thinking hard enough ;-)

> One consequence of this is that pathname-based models must control who is 
> allowed to create aliases where, of course.

Absolutely.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
