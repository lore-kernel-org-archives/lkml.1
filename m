Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbYDXPiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbYDXPiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYDXPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:38:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56641 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYDXPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:38:41 -0400
Date: Thu, 24 Apr 2008 16:38:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424153828.GL15214@ZenIV.linux.org.uk>
References: <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu> <20080424142857.GF15214@ZenIV.linux.org.uk> <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu> <20080424144448.GH15214@ZenIV.linux.org.uk> <E1Jp2pD-00043W-IF@pomaz-ex.szeredi.hu> <20080424151235.GJ15214@ZenIV.linux.org.uk> <E1Jp3DA-00048z-Vl@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp3DA-00048z-Vl@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 05:18:12PM +0200, Miklos Szeredi wrote:

> > Oh, for fuck sake...  grep and ye shall see.  Right next to setattr we
> > have nfsd4_set_nfs4_acl(), with pair of set_nfsv4_acl_one().  I'd rather
> > have those two covered by a single will/wont range, TYVM.
> > 
> > nfsd_create() will happily do vfs_mkdir() and nfsd_create_setattr().  Ditto.
> 
> Please read the patches?  I've left exactly these
> mnt_want_write/drop_write() calls in place, and removed all the
> others.
 
You've left _what_ in place?  nfsd4_set_nfs4_acl() currently doesn't have
that single range - fh_verify() + set_nvfs4_acl_one() + set_nfsv4_acl_one().
And AFAICS you do nothing of that kind there.
