Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZDQENp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZDQENp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZDQENg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:13:36 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:59221 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZDQENf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:13:35 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Q: NFSD readdir in linux-2.6.28 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090416214545.GA2237@fieldses.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <20090416214545.GA2237@fieldses.org>
Date: Fri, 17 Apr 2009 13:13:09 +0900
Message-ID: <7106.1239941589@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. Bruce Fields":
> > > After the commit (above), nfsd_readdir/nfsd_buffered_readdir/vfs_readdir
> > > calls nfsd_buffered_filldir(), and nfs3svc_encode_entry_plus() is called
> > > later.
> > > In this sequence, lookup_one_len() is called without i_mutex held.
	:::
> Yipes--is this problem still here?

Yes.


J. R. Okajima
