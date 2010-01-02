Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387Ab0ABDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0ABDw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 22:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337Ab0ABDw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 22:52:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61229 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0ABDw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 22:52:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NFgzCuWEgvosrcSBUnmV5D0lW4ZEMAPRGgH+W5HDtWdLRNrfTo4/dMM5zV0BXA0fiY
         zTR9Pd3cUeEN4cCeE/mGJ+mwwHGmnqV3GGZGocFdAQ8ZIWdkzkqYih+5GUWH1uii3tTj
         HOurSY+iL7b1ppI70Z40O5NmLDNJpzNgh5HkM=
Date: Sat, 2 Jan 2010 04:52:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] reiserfs lock inversion fixes on xattr
Message-ID: <20100102035221.GB5238@nowhere>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com> <1262205747-9208-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de> <20100101092944.GB12203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101092944.GB12203@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 10:29:44AM +0100, Ingo Molnar wrote:
> 
> * Christian Kujau <lists@nerdbynature.de> wrote:
> 
> > On Wed, 30 Dec 2009 at 21:42, Frederic Weisbecker wrote:
> > > I hope you can give it a try (and/or review) before I send the whole
> > > to Linus.
> > 
> > Without your patches, "dbench -x" was pretty much instantly causing the 
> > threads to lock up, forcing me to reboot the box. With LOCKDEP enabled, 
> > warnings were printed. After applying your patches (and a reboot) I've run 
> > "dbench -x" for quite a while now with different runtimes and number of
> > clients and it's not locking up any more. I've tested with:
> > 
> > CONFIG_REISERFS_FS=y
> > CONFIG_REISERFS_CHECK=y
> > CONFIG_REISERFS_PROC_INFO=y
> > CONFIG_REISERFS_FS_XATTR=y
> > CONFIG_REISERFS_FS_POSIX_ACL=y
> > # CONFIG_REISERFS_FS_SECURITY is not set
> > 
> > ...and a few "Kernel hacking" options set. Full config and dmesg:
> > 
> >    http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/t3/
> > 
> >    (although I'm not really testing -rc1 but latest mainline -git
> >     and your changes pulled)
> > 
> > So, feel free to add:
> > 
> >   Tested-by: Christian Kujau <lists@nerdbynature.de>
> 
> Frederic, i'd suggest you send this tree to Linus with Christian's tested-by 
> tags added ASAP - we better have these fixes in -rc3.
> 
> Thanks,
> 
> 	Ingo


Yep, done :)

