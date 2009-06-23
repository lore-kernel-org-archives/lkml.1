Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbZFWQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbZFWQx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbZFWQxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:53:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760490AbZFWQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:53:39 -0400
Date: Tue, 23 Jun 2009 12:53:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Message-ID: <20090623165337.GA8204@infradead.org>
References: <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16370.1245772337@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:52:17PM +0100, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Right, but that makes it useless for things which want to open it
> > despite having no permission on the file.
> 
> For my purposes, if I'm going to emulate pioctl() in userspace, I also need to
> be able to open device files that don't have drivers available, and when you
> do open a dev file in this manner, it must _not_ call the ->open() routine of
> the device driver.

Last time I checked afs didn't support device files at all.  And limited
the magic commands to not work on device files doesn't sound to bad.

Of course specifying what these magic tools are actually supposed to do
would be an interesting start.
