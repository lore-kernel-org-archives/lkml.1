Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbZEAQRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbZEAQRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZEAQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:17:46 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:44103 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZEAQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:17:45 -0400
Date: Fri, 1 May 2009 09:17:45 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501161745.GA29627@puku.stupidest.org>
References: <1241097822.2516.3.camel@poy> <20090501065754.GA30626@puku.stupidest.org> <20090501140108.GA20846@kroah.com> <20090501155342.GA28350@puku.stupidest.org> <20090501160951.GA17433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501160951.GA17433@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:09:51AM -0700, Greg KH wrote:

> You usually need to do more.  We started out just only doing block
> devices, but you also need the memory devices, and console, and a
> few others as well.

I could add that.  It's probably not hard.

What's more, it has liblkid support so you could mount by label and a
few other things.  It seems reasonable that you could add lvm support
as well.

The main downsides I see right now are:

  - it's not in the kernel by default

  - it's actually quite large beacuse i link against glibc

It's not clear these are show stoppers long term.


> After all that, you have already written another tool, which seems
> like overkill when we can do it all in the kernel so much easier and
> simpler.

I think that's a different argument.  Doesn't the same logic imply we
shouldn't have udevd?
