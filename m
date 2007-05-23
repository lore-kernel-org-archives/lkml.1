Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXEWMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXEWMk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXEWMkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:40:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbXEWMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:40:17 -0400
Date: Wed, 23 May 2007 13:40:13 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523124013.GV4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu> <20070523073658.GO4095@ftp.linux.org.uk> <1179923682.6480.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179923682.6480.18.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 08:34:42AM -0400, Trond Myklebust wrote:
> On Wed, 2007-05-23 at 08:36 +0100, Al Viro wrote:
> > On Wed, May 23, 2007 at 09:19:17AM +0200, Miklos Szeredi wrote:
> > > > Eh...  Arbitrary limitations are fun, aren't they?
> > > 
> > > But these mounts _are_ special.  There is really no point in moving or
> > > pivoting them.
> > 
> > pivoting - probably true, moving... why not?
> 
> Moving would be an implementation artefact that doesn't really
> correspond to any useful operation on the filesyst
> 
> AFAIK, most filesystems that have implemented subfiles (excepting
> Reiser4 of course) do not allow you to rename or move the subfile
> directory or its contents from one parent file to another.

If that's about xattr and nothing else, colour me thoroughly uninterested.
If it might have other interesting uses, OTOH...
