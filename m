Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbXHHGRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbXHHGRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXHHGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:16:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47832 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbXHHGQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:16:55 -0400
Date: Wed, 8 Aug 2007 08:18:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
Message-ID: <20070808061812.GA13867@uranus.ravnborg.org>
References: <46B943D3.9020207@lwfinger.net> <20070807.213724.27783161.davem@davemloft.net> <46B94C12.2000301@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B94C12.2000301@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 11:52:34PM -0500, Larry Finger wrote:
> David Miller wrote:
> >From: Larry Finger <Larry.Finger@lwfinger.net>
> >Date: Tue, 07 Aug 2007 23:17:23 -0500
> >
> >>I am getting the following error message from drivers/base/core.c:
> >>
> >>net eth1: device_rename: sysfs_create_symlink failed (-17)
> >>
> >>Upon investigation, the call generating the error is renaming 'eth1' to 
> >>'eth1'. The following patch suppresses the error.
> >
> >I think this check belongs in udev not in the kernel.  Thankfully
> >this message at least tells us it is happening, please don't
> >remove it.
> >
> >I'm pretty sure it's UDEV doing this, and it should not try to rename
> >a netdevice to what it already is named.
> >
> 
> Yes, it is most likely coming from udev. Do you know who maintains udev? 
> Google didn't give an answer in the first two pages.
Kay Sievers. Se contact details on his udev page here:
http://vrfy.org/log/recent-state-of-udev.html

	Sam
