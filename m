Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbZEAPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbZEAPxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbZEAPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:53:45 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:56151 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbZEAPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:53:44 -0400
Date: Fri, 1 May 2009 08:53:42 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501155342.GA28350@puku.stupidest.org>
References: <1241097822.2516.3.camel@poy> <20090501065754.GA30626@puku.stupidest.org> <20090501140108.GA20846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501140108.GA20846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:01:08AM -0700, Greg KH wrote:

> Right now it does, and it takes about 1-2 seconds to do so depending
> on the hardware.

The code I have only does block devices right now, but it could do
more.  Even if it was 10x slower it wouldn't be close to 1-2 seconds.

> Which is over double the time it takes to boot the kernel entirely
> these days, so it is quite noticable.

So the kernel takes 500-1000ms then?  That seems really high.

