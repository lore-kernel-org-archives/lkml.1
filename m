Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZFRDX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZFRDX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZFRDXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:23:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFRDXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:23:15 -0400
Date: Wed, 17 Jun 2009 23:22:49 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH] Userland for VFS based Union Mount (V3)
Message-ID: <20090618032249.GD15048@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <20090518204019.GC15754@shell> <20090521135315.GA12502@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521135315.GA12502@webber.adilger.int>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:53:15AM -0400, Andreas Dilger wrote:
> On May 18, 2009  16:40 -0400, Valerie Aurora wrote:
> > @@ -705,8 +707,9 @@ struct ext2_dir_entry_2 {
> >  #define EXT2_FT_FIFO		5
> >  #define EXT2_FT_SOCK		6
> >  #define EXT2_FT_SYMLINK		7
> > +#define EXT2_FT_WHT		8
> >  
> > -#define EXT2_FT_MAX		8
> > +#define EXT2_FT_MAX		9
> 
> What about the EXT2_FT_FALLTHROUGH used in the union mount patches?

We're UNIX engineers, we don't include unnecessary letters. :)

Thanks, I added EXT2_FT_FALLTHRU and made it possible to specify "-O
whiteout" in my latest patchset.

-VAL
