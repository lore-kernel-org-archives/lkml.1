Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYL3R3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYL3R3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYL3R3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:29:22 -0500
Received: from verein.lst.de ([213.95.11.210]:58970 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYL3R3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:29:22 -0500
Date: Tue, 30 Dec 2008 18:29:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: access(2) regressions in current mainline
Message-ID: <20081230172901.GA5610@lst.de>
References: <20081230170941.GA5083@lst.de> <20081230134248.GA30124@lst.de> <24505.1230656810@redhat.com> <32709.1230657626@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32709.1230657626@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:20:26PM +0000, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Tue, Dec 30, 2008 at 05:06:50PM +0000, David Howells wrote:
> > > Did this test ever get run on the linux-next tree prior to the merge?  If
> > > so, what was the result?
> > 
> > I have no idea if people ever ran it, and if they did they will to
> > respond for themselves..
> 
> Is it possible for me to grab the XFS test GIT tree for myself?  And can it be
> run on a non-XFS filesystem?

You can grab it, although currently the trees are undergoing some
changes, so what you pull today might now be there tomorrow..

Try to grab git://oss.sgi.com/xfs-cmds, it's in the xfstests subdir.

The QA harness currently only runs on xfs, nfs and udf, but this
particular test program should work on any fs if run outside the
testharness.

> 
> David
---end quoted text---
