Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZAVTx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZAVTx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZAVTxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:53:19 -0500
Received: from mga10.intel.com ([192.55.52.92]:46230 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbZAVTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:53:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,307,1231142400"; 
   d="scan'208";a="659338878"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 4/5] debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n
Date: Thu, 22 Jan 2009 11:53:11 -0800
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090121051855.GA3665@kroah.com> <20090122174152.de6cc08e.sfr@canb.auug.org.au> <20090122182214.GA11328@suse.de>
In-Reply-To: <20090122182214.GA11328@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221153.12064.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Greg KH wrote:
> On Thu, Jan 22, 2009 at 05:41:52PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >
> > On Tue, 20 Jan 2009 21:19:56 -0800 Greg Kroah-Hartman <gregkh@suse.de> 
wrote:
>
> snip [...]
>
> > > > @@ -162,6 +162,13 @@ static inline struct dentry 
> > > *debugfs_create_x32(const char *name, mode_t mode, return
> > > ERR_PTR(-ENODEV);
> > >  }
> > >
> > > +struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
> >
> > This needs to be "static inline".  See my other email about linux-next
> > breakage due to this.
>
> This is now resolved in my tree, sorry about this.

Ouch -- that was my fault. Sorry for messing up something so basic.

-- 
Inaky
