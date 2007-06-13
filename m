Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXFMGtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXFMGtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXFMGtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:49:41 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:59985 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbXFMGtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:49:40 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Date: Wed, 13 Jun 2007 08:49:36 +0200
User-Agent: KMail/1.9.4
Cc: Jason Lunz <lunz@falooley.org>, DervishD <lkml@dervishd.net>
References: <20070611101319.GA14284@DervishD> <20070612210943.GA27509@metaxa.reflex>
In-Reply-To: <20070612210943.GA27509@metaxa.reflex>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706130849.37662.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 23:09, Jason Lunz wrote:
> In gmane.linux.kernel, you wrote:
> >     I was wondering: is there any reason not to use ext2 on an USB
> > pendrive? Really my question is not only about USB pendrives, but any
> > device whose storage is flash based. Let's assume that the device has a
> > good quality flash memory with wear leveling and the like...
>
> Have a look at the UBI layer. It adds wear-levelling to MTD devices.  Of
> course, to use it on a regular blockdev like this you'll have to do
> something like usb-storage (sd) -> block2mtd -> ubi -> jffs2. But it can
> be done afaik.

Then you will do some kind of wear leveling (jffs2) over wear leveling 
(pendrive). Does this makes sense?

Juergen
