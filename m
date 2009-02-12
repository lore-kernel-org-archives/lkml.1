Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZBLEN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZBLEN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 23:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZBLENt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 23:13:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:61383 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZBLENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 23:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=tmmx8PwkDxiPMnSIqeXyeGYw4v4ygx2Td7lunm8l7khRYuw8s7Ne7/Jj/B7xl9PtUq
         i4VZDOmmghEZmhsOuJvOOkPkYC5PDTkaiqyD3zBKZimsuzelqCtpDNlaEqZkH+AZRc0n
         A9/vFdD39twNbx9miW50w52lOvJKrXjd8IFxM=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: reiserfs-devel@vger.kernel.org
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
Date: Thu, 12 Feb 2009 05:13:37 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.15r4; KDE/4.2.0; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jan Kara <jack@suse.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <499305AD.4020900@oracle.com> <20090211171324.GC13817@duck.suse.cz> <20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902120513.39382.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 12 Februar 2009, KOSAKI Motohiro wrote:
> > On Wed 11-02-09 09:06:53, Randy Dunlap wrote:
> > > akpm@linux-foundation.org wrote:
> > > > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> > > >
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > >
> > > > and will soon be available at
> > > >
> > > >    git://git.zen-sources.org/zen/mmotm.git
> > >
> > > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:456: error: implicit
> > > declaration of function 'DQUOT_TRANSFER'
> > > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:596: error: implicit
> > > declaration of function 'DQUOT_ALLOC_INODE'
> > > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:597: error: implicit
> > > declaration of function 'DQUOT_DROP'
> > > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:611: error: implicit
> > > declaration of function 'DQUOT_FREE_INODE'
> >
> >   Ah, out of tree filesystems... Could some of Reiser4 guys convert the
> > quota names (they should be vfs_dq_transfer, vfs_dq_alloc_inode,
> > vfs_dq_drop, vfs_dq_free_inode)? I suppose I could do it myself but I'm
> > not sure if it won't clash with some other changes.
> >   Thanks for report Randy.
> >
> > 									Honza
>
> Andrew, recently I've never seen any reiser4 activity in LKML.
> I would suggest to remove it from -mm.

maybe you should look at the reiser4 list before asking for that?
