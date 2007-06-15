Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXFOQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXFOQlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXFOQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:41:16 -0400
Received: from [212.112.238.170] ([212.112.238.170]:35577 "EHLO
	longford.lazybastard.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbXFOQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:41:16 -0400
Date: Fri, 15 Jun 2007 18:36:25 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070615163625.GC7747@lazybastard.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614201714.GC1928@DervishD> <20070614203800.GG31984@lazybastard.org> <20070615161644.GB2373@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615161644.GB2373@DervishD>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 June 2007 18:16:44 +0200, DervishD wrote:
> 
>     Yes, I understand. That's worse than I thought. I was right now
> thinking about "PortableApps", a set of free software applications that
> are a little bit modified to work from a pendrive in Windows. Very
> useful, because you can carry your OpenOffice (or AbiWord) and Firefox,
> for example, to any Windows you're doomed to use. This applications
> write repeteadly to the pendrive (specially Firefox...), and I think
> they may wear the drive prematurely if used extensively.

Possibly, yes.  Estimates based on unknown numbers are hard, though.

>     So you have a zone which is unusable. Decent filesystems allow you
> to mark some blocks as "dontuse" (ext2, for example). Does FAT allow
> this?

I don't know.  If things get bad enough that you experience
uncorrectable errors, I'd just trash the stick and get a new one
instead.  Trouble is - with a controller chip doing the error
correction, you have no means of knowing when this happens.

>     I think I will be writing the pendrive, almost fully, once a week
> (enough for an image of my home directory). That means less than 1GiB
> written each week. That means 50-100 (in the worst case, making two
> backups a week instead of one) writings each year in each block.

Writing everything once a week is harmless.  Filling the whole device is
best-case behaviour.  Local hot spots are the problem.

Jörn

-- 
Anything that can go wrong, will.
-- Finagle's Law
