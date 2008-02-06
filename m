Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbYBFXgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbYBFXgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbYBFXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:36:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52907
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbYBFXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:36:44 -0500
Date: Wed, 06 Feb 2008 15:37:14 -0800 (PST)
Message-Id: <20080206.153714.133821225.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080206233117.GA28931@suse.de>
References: <20080206.152639.35541094.davem@davemloft.net>
	<20080206233117.GA28931@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 15:31:17 -0800

> On Wed, Feb 06, 2008 at 03:26:39PM -0800, David Miller wrote:
> > I'm pretty sure the following changeset is to blame:
> > 
> > commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
> > Author: Kay Sievers <kay.sievers@vrfy.org>
> > Date:   Mon May 21 22:08:01 2007 +0200
> > 
> >     Driver core: convert block from raw kobjects to core devices
> >     
> >     This moves the block devices to /sys/class/block. It will create a
> >     flat list of all block devices, with the disks and partitions in one
> >     directory. For compatibility /sys/block is created and contains symlinks
> >     to the disks.
> 
> So I'm guessing if you revert this it works?

Unfortunately that's not so simple to test because afterwards there
are changesets where all the files under block/ got renamed and as
such I can't just revert that single patch from the tip.

> Do you have CONFIG_SYSFS_DEPRECATED=Y or N?

I have SYSFS_DEPRECATED=y
