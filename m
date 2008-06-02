Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYFBFnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYFBFnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYFBFnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:43:22 -0400
Received: from lazybastard.de ([212.112.238.170]:56068 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFBFnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:43:21 -0400
Date: Mon, 2 Jun 2008 07:42:49 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 2/7] cramfs: create unique inode numbers
Message-ID: <20080602054240.GA19219@logfs.org>
References: <20080531152013.031903990@arndb.de> <20080531153510.692084580@arndb.de> <20080601165048.GC13094@logfs.org> <200806012324.51734.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806012324.51734.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 June 2008 23:24:51 +0200, Arnd Bergmann wrote:
> On Sunday 01 June 2008, Jörn Engel wrote:
> > 
> > Couldn't this cause problems for NFS?  The same inode no longer has a
> > stable inode number across reboots.  Basing on dentry location can also
> > be an information leak and cause problems on 64bit machines with old
> > userspace.
> 
> Sorry if I was not clear with this: I meant dentry location on disk,
> not in memory. So the inode number is still stable across reboots and
> does not leak data, it is just different from before.

In that case I'd better retract my whole comment. ;)

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
