Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbZEAOCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbZEAOCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbZEAOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:01:48 -0400
Received: from kroah.org ([198.145.64.141]:48224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761633AbZEAOBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:01:47 -0400
Date: Fri, 1 May 2009 07:01:08 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501140108.GA20846@kroah.com>
References: <1241097822.2516.3.camel@poy> <20090501065754.GA30626@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501065754.GA30626@puku.stupidest.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:57:54PM -0700, Chris Wedgwood wrote:
> On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
> 
> > Devtmpfs lets the kernel create a tmpfs very early at kernel
> > initialization, before any driver core device is registered. Every
> > device with a major/minor will have a device node created in this
> > tmpfs instance. After the rootfs is mounted by the kernel, the
> > populated tmpfs is mounted at /dev. In initramfs, it can be moved to
> > the manually mounted root filesystem before /sbin/init is executed.
> 
> Why can't the initramfs create /dev and populate it?

Right now it does, and it takes about 1-2 seconds to do so depending on
the hardware.

Which is over double the time it takes to boot the kernel entirely these
days, so it is quite noticable.

thanks,

greg k-h
