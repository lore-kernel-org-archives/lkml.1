Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZEAHH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZEAHH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 03:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZEAHHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 03:07:50 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:46545 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZEAHHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 03:07:50 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2009 03:07:50 EDT
Date: Thu, 30 Apr 2009 23:57:54 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501065754.GA30626@puku.stupidest.org>
References: <1241097822.2516.3.camel@poy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241097822.2516.3.camel@poy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:

> Devtmpfs lets the kernel create a tmpfs very early at kernel
> initialization, before any driver core device is registered. Every
> device with a major/minor will have a device node created in this
> tmpfs instance. After the rootfs is mounted by the kernel, the
> populated tmpfs is mounted at /dev. In initramfs, it can be moved to
> the manually mounted root filesystem before /sbin/init is executed.

Why can't the initramfs create /dev and populate it?
