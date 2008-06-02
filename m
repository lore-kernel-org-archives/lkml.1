Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYFBTAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYFBTAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYFBTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:00:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53647 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbYFBTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:00:11 -0400
Date: Mon, 2 Jun 2008 13:59:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602185953.GA14108@us.ibm.com>
References: <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu> <20080602104203.GA21898@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602104203.GA21898@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig (hch@infradead.org):
> On Mon, Jun 02, 2008 at 11:52:52AM +0200, Miklos Szeredi wrote:
> > These patches fix several issues raised at previous submissions:
> > 
> >  - passing NULL vfsmounts
> >  - using nameidata
> >  - using extra stack for vfsmount argument
> > 
> > So, it seems to me that there's in fact no issues remaining and the
> > best excuse you can come up with is that it's a dumb idea.  Well,
> > that's not a very imressive technical argument IMNSHO.
> 
> Well, pathname based access control is a dumb idea, and we've been
> through this N times.  You've also been told that vfs_ routines should
> remain without vfsmount, and no that's not a stack-related issue no idea
> where that part came from.

Sorry, noone else asked, so just out of curiosity - the *actual* reason
is api layering?  Or am I missing another reason?

thanks,
-serge
