Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXFLVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXFLVge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXFLVg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:36:27 -0400
Received: from crown.reflexsecurity.com ([72.54.139.163]:42028 "EHLO
	crown.reflexsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXFLVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:36:26 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 17:36:26 EDT
Date: Tue, 12 Jun 2007 17:09:45 -0400
From: Jason Lunz <lunz@falooley.org>
To: DervishD <lkml@dervishd.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070612210943.GA27509@metaxa.reflex>
References: <20070611101319.GA14284@DervishD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611101319.GA14284@DervishD>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel, you wrote:
>     I was wondering: is there any reason not to use ext2 on an USB
> pendrive? Really my question is not only about USB pendrives, but any
> device whose storage is flash based. Let's assume that the device has a
> good quality flash memory with wear leveling and the like...

Have a look at the UBI layer. It adds wear-levelling to MTD devices.  Of
course, to use it on a regular blockdev like this you'll have to do
something like usb-storage (sd) -> block2mtd -> ubi -> jffs2. But it can
be done afaik.

Jason
