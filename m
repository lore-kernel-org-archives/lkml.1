Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032Ab0ARGB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0ARGB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 01:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467Ab0ARGB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 01:01:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab0ARGBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 01:01:21 -0500
Date: Mon, 18 Jan 2010 06:01:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sage Weil <sage@newdream.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: vfs tree build warning
Message-ID: <20100118060118.GT19799@ZenIV.linux.org.uk>
References: <20100118131139.1ef42c6f.sfr@canb.auug.org.au> <Pine.LNX.4.64.1001172032590.16533@cobra.newdream.net> <20100118164148.3452f553.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118164148.3452f553.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:41:48PM +1100, Stephen Rothwell wrote:
> Hi Sage,
> 
> On Sun, 17 Jan 2010 20:34:29 -0800 (PST) Sage Weil <sage@newdream.net> wrote:
> >
> > I can put this in the for-next branch of the ceph tree.
> 
> Not unless you first merge the vfs tree into the ceph tree ...

Grr...  How about putting these two commits on a separate (and absolutely
unchanging) branch?  I'd rather live without being unable to rediff
for-next if needed and that way nfs, ceph, etc. could pull _that_ instead.
