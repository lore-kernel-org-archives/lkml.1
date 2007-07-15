Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbXGOWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbXGOWXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbXGOWX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:23:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbXGOWXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:23:25 -0400
Date: Sun, 15 Jul 2007 23:23:23 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
Message-ID: <20070715222323.GG21668@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184534001.2765.5.camel@entropy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 02:13:21PM -0700, Nicholas Miell wrote:
> 
> I suspect he was asking for 
> 
> int getxattrat(int fd, const char *path, const char *name, void *value, 
> 		size_t size, int flags)
> int setxattrat(int fd, const char *path, const char *name, void *value,
> 		size_t size, int xattrflags, int atflags)
> 
> rather than the ability to access xattrs as files.

Just one question: what the bleeding hell for?  Not that the rest of
..at() family made any damn sense as an interface...

> > > BTW, why is fstatat called fstatat and not statat? (Same goes for 
> > > futimesat.) It does not take a file descriptor for the file argument. 
> > > Otherwise we'd also need fopenat/funlinkat, etc. Any reasons?
> > 
> > Ulrich having an odd taste?
> 
> Solaris compatibility.

"Sun having no taste whatsoever"
