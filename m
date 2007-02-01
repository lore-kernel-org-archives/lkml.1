Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXBAAFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXBAAFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXBAAFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:05:36 -0500
Received: from www.osadl.org ([213.239.205.134]:41548 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933368AbXBAAFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:05:36 -0500
Subject: Re: 2.6.20-rc6 ramdisk problem
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Robert Hancock <hancockr@shaw.ca>
Cc: michal.k.k.piotrowski@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45C12C3E.6010902@shaw.ca>
References: <fa.nr9vhGrVS5zmSNQEe1vQ/Ktii9w@ifi.uio.no>
	 <45C12C3E.6010902@shaw.ca>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 01:06:26 +0100
Message-Id: <1170288386.29240.234.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 17:54 -0600, Robert Hancock wrote:
> I'm not sure if there's an inherent max ramdisk size limit, however I 
> should point out that in most cases, using a tmpfs or ramfs file system 
> is better than old-style ramdisks. Those filesystems return unused 
> memory to the kernel (ramdisks statically allocate the entire space) and 
> also avoid the filesystem overhead of ramdisks (the files are mapped 
> into pagecache directly).

This is not a question of what's better or not. 

Michal stepped into a real life problem:

1. ramdisk gets created in the first place w/o problems
2. formatting the same ramdisk succeeds
3. trying to use it fails

So either #1 or #2 should have failed in the first place. Failing in #3
is definitely a BUG in #1 or #2.

How does your advise help to fix that BUG ? Ignoring it by using
something else ?

	tglx


