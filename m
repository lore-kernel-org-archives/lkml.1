Return-Path: <linux-kernel-owner+w=401wt.eu-S1161448AbXB0AEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161448AbXB0AEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161478AbXB0AEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:04:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54791 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161449AbXB0AEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:04:45 -0500
Date: Tue, 27 Feb 2007 00:03:18 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, a.gruenbacher@computer.org,
       nathans@sgi.com, bunk@stusta.de, linux-kernel@vger.kernel.org,
       jmorris@redhat.com, dwmw2@infradead.org
Subject: Re: include/linux/xattr.h: how much userpace visible?
Message-ID: <20070227000318.GA3448@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Miller <davem@davemloft.net>, a.gruenbacher@computer.org,
	nathans@sgi.com, bunk@stusta.de, linux-kernel@vger.kernel.org,
	jmorris@redhat.com, dwmw2@infradead.org
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org> <45E36D39.2030605@zytor.com> <20070226.154308.112620497.davem@davemloft.net> <45E372CA.9020709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E372CA.9020709@zytor.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 03:52:42PM -0800, H. Peter Anvin wrote:
> David Miller wrote:
> >>>
> >>However, it would be better if the ABI constants were exported, or at 
> >>least *exportable* (using a __KERNEL_XATTR_MACROS test macro or 
> >>something like that.)
> >
> >This is the same situation as the socket.h issue we're trying
> >to figure out what to do about.
> >
> >wrt. the socket.h case I think I'm going to revert the guilty
> >changeset for now until a better scheme is implemented
> 
> Indeed it is (as well as <linux/stat.h>).
> 
> I believe the use of feature macros is probably the way to go; that way 
> userspace can request subsets, which can vary from libc to libc.
> 
> There is, of course, the "ABI language" variant, but I don't see that 
> happening unless someone has a lot of time to spend on it.

What's the problem of exposing all these APIs unconditionally?
glibcs should either use all information from the linux/ headers
or nothing at all, but not depend on hiding some bits.
