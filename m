Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYFBKmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYFBKmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYFBKmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:42:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYFBKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:42:05 -0400
Date: Mon, 2 Jun 2008 06:42:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602104203.GA21898@infradead.org>
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 11:52:52AM +0200, Miklos Szeredi wrote:
> These patches fix several issues raised at previous submissions:
> 
>  - passing NULL vfsmounts
>  - using nameidata
>  - using extra stack for vfsmount argument
> 
> So, it seems to me that there's in fact no issues remaining and the
> best excuse you can come up with is that it's a dumb idea.  Well,
> that's not a very imressive technical argument IMNSHO.

Well, pathname based access control is a dumb idea, and we've been
through this N times.  You've also been told that vfs_ routines should
remain without vfsmount, and no that's not a stack-related issue no idea
where that part came from.
