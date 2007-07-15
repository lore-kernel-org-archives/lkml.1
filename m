Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXGOVNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXGOVNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXGOVN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:13:29 -0400
Received: from sccrmhc15.comcast.net ([204.127.200.85]:41916 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXGOVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:13:29 -0400
Subject: Re: *at syscalls for xattrs?
From: Nicholas Miell <nmiell@comcast.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070715205313.GE21668@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
	 <20070715205313.GE21668@ftp.linux.org.uk>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 14:13:21 -0700
Message-Id: <1184534001.2765.5.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 21:53 +0100, Al Viro wrote:
> On Sun, Jul 15, 2007 at 09:46:27PM +0200, Jan Engelhardt wrote:
> > Hi,
> > 
> > 
> > recently, the family of *at() syscalls and functions (openat, fstatat, 
> > etc.) have been added to Linux and Glibc, respectively.
> > In short: I am missing xattr at functions :)
> 
> No.  They are not fscking forks.  They are almost as revolting, but
> not quite on the same level.

I suspect he was asking for 

int getxattrat(int fd, const char *path, const char *name, void *value, 
		size_t size, int flags)
int setxattrat(int fd, const char *path, const char *name, void *value,
		size_t size, int xattrflags, int atflags)

rather than the ability to access xattrs as files.

> > BTW, why is fstatat called fstatat and not statat? (Same goes for 
> > futimesat.) It does not take a file descriptor for the file argument. 
> > Otherwise we'd also need fopenat/funlinkat, etc. Any reasons?
> 
> Ulrich having an odd taste?

Solaris compatibility.

-- 
Nicholas Miell <nmiell@comcast.net>

