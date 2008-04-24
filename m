Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbYDXPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbYDXPnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYDXPna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:43:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43294 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYDXPn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:43:29 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424153828.GL15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 16:38:29 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu> <20080424142857.GF15214@ZenIV.linux.org.uk> <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu> <20080424144448.GH15214@ZenIV.linux.org.uk> <E1Jp2pD-00043W-IF@pomaz-ex.szeredi.hu> <20080424151235.GJ15214@ZenIV.linux.org.uk> <E1Jp3DA-00048z-Vl@pomaz-ex.szeredi.hu> <20080424153828.GL15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp3bT-0004Gm-Rt@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 17:43:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Oh, for fuck sake...  grep and ye shall see.  Right next to setattr we
> > > have nfsd4_set_nfs4_acl(), with pair of set_nfsv4_acl_one().  I'd rather
> > > have those two covered by a single will/wont range, TYVM.
> > > 
> > > nfsd_create() will happily do vfs_mkdir() and nfsd_create_setattr().  Ditto.
> > 
> > Please read the patches?  I've left exactly these
> > mnt_want_write/drop_write() calls in place, and removed all the
> > others.
>  
> You've left _what_ in place?  nfsd4_set_nfs4_acl() currently doesn't have
> that single range - fh_verify() + set_nvfs4_acl_one() + set_nfsv4_acl_one().
> And AFAICS you do nothing of that kind there.
> 

Yes I did.  See only caller of nfsd4_set_nfs4_acl() in nfs4proc.c.

Miklos
