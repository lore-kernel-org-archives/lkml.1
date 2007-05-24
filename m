Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbXEXEJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbXEXEJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbXEXEI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:08:59 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:44870 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbXEXEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:08:58 -0400
Subject: Re: [PATCH 6/6] UNUSUAL_DEV: Sync up some reported devices from
	Ubuntu
From: Ben Collins <ben.collins@ubuntu.com>
To: Phil Dibowitz <phil@ipom.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <46550DA7.60504@ipom.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	 <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
	 <46550DA7.60504@ipom.com>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 24 May 2007 00:09:10 -0400
Message-Id: <1179979750.12570.175.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 20:59 -0700, Phil Dibowitz wrote:
> Ben Collins wrote:
> > Various unusual dev entries accumulated from Ubuntu bug reports.
> > 
> > CC: Phil Dibowitz <phil@ipom.com>
> 
> NACK. Two fixes I'd like to see fixed.
> 
> > +/* SanDisk that has a second LUN for a driver ISO, reported by
> > + * Ben Collins <bcollins@ubuntu.com> */
> > +UNUSUAL_DEV( 0x0781, 0x5406, 0x0000, 0xffff,
> 
> Please use specific device IDs unless you have reason to believe the range
> as a whole is affected (or large portions at least)

Unfortunately, I don't have this device anymore. I based it on an
existing entry, so mislead myself there.

> > +/* Reported by Edward Chapman <[EMAIL PROTECTED]>
> > +   Netac OnlyDisk Mini U2CV2 512MB USB 2.0 Flash Drive */
> > +UNUSUAL_DEV( 0x0dd8, 0xd202, 0x0000, 0x9999,
> 
> Same here.

This one I snatched off a mailing list archive somewhere. Was reported
to fix a bug reported to us. However, it is so old I can't find any
information on the bug submitters original USB ids.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

