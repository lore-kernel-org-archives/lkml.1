Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYBSTbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYBSTbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbYBSTaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:30:18 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53111 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760728AbYBSTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:30:16 -0500
Date: Tue, 19 Feb 2008 11:51:14 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 5/8] try parent numa_node at first before using
 =?iso-8859-1?q?default=09v2?=
In-reply-to: <20080219175423.GC8344@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802191151.14717.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
 <200802190320.41210.yinghai.lu@sun.com> <20080219175423.GC8344@kroah.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 09:54:23 am Greg KH wrote:
> On Tue, Feb 19, 2008 at 03:20:41AM -0800, Yinghai Lu wrote:
> > 
> > in the device_add, we try to use use parent numa_node.
> > need to make sure pci root bus's bridge device numa_node is set.
> > then we could use device->numa_node direclty for all device.
> > and don't need to call pcibus_to_node().
> > 
> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> This should be split into different patches, one for the driver core,
> and one for the PCI stuff as they are doing totally different things
> here.

but one for the driver core, rely on the one for pci stuff.
without the one pci stuff, the one for the driver core doesn't work.

last time you already said it's ok.  I will dig the mail out if needed.

YH

