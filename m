Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZAASNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZAASNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 13:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZAASND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 13:13:03 -0500
Received: from lazybastard.de ([212.112.238.170]:49882 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZAASNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 13:13:01 -0500
Date: Thu, 1 Jan 2009 19:12:23 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-osd development <osd-dev@open-osd.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
       avishay@gmail.com, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Message-ID: <20090101181223.GA29913@logfs.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com> <495C92C8.5040702@garzik.org> <495CD1C4.1030605@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495CD1C4.1030605@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 January 2009 16:23:00 +0200, Benny Halevy wrote:
> 
> Personally, I'm not sure if maintaining that intimate knowledge in a
> user space program is an ideal model with respect to keeping both
> in sync, avoiding code duplication, and dealing with upgrade issues
> (e.g. upgrading the kernel and not the user space utils)

None of those problems actually matter, because you will have them
anyway.  If your filesystem is any good, someone will reimplement it for
Windows, Grub, UBoot, Solaris or some other system.  And even if it
isn't any good, you still need to stay compatible with your own
implementation from last year.

Ok, maybe code duplication is a valid concern.  But that will hardly
outweigh the arguments in favor of a userland mkfs.  The only exception
I am aware of is jffs2, where a newly erased flash happens to be a valid
(empty) filesystem.  And even there you can view flash_eraseall as a
trivial mkfs program. ;)

Jörn

-- 
It's just what we asked for, but not what we want!
-- anonymous
