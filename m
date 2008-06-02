Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYFBLYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYFBLYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYFBLYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:24:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52329 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYFBLYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:24:08 -0400
Date: Mon, 2 Jun 2008 05:23:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602112350.GB8562@parisc-linux.org>
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 09:02:14AM +0200, Miklos Szeredi wrote:
> I maintain, that moving lsm hooks into callers is insane.  And that's
> *the* sanest alternative that anybody has been able to come up with to
> passing down vfsmounts into the vfs.

Not so.  I showed how pathname-based security could be done *without*
passing vfsmounts down at all.  Unfortunately, you weren't interested.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
