Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZBBMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZBBMd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZBBMds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:33:48 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46952 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZBBMdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:33:47 -0500
Date: Mon, 2 Feb 2009 13:33:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Folkert van Heusden <folkert@vanheusden.com>
cc: Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29rc1 breakes usb: hiddev device no longer available
In-Reply-To: <20090127195229.GA6158@vanheusden.com>
Message-ID: <alpine.LRH.1.10.0902021333180.22097@twin.jikos.cz>
References: <20090126170130.GG6158@vanheusden.com> <20090126182707.GI6158@vanheusden.com> <200901262005.08168.oliver@neukum.org> <20090127195229.GA6158@vanheusden.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Folkert van Heusden wrote:

> > > > Since version 2.6.29rc1 querying cleware USb devices no longer works.
> > > > 2.6.28 works fine. 2.6.29-rc2 also no longer works.
> > > the is the FAILURE situation (2.6.29-rc*):
> > > open("/dev/usb/hiddev0", O_RDWR)        = 3
> > > ioctl(3, HIDIOCGDEVINFO, 0xbf90c0d8)    = 0
> > > ioctl(3, HIDIOCAPPLICATION, 0)          = -6291455
> > > ioctl(3, HIDIOCGSTRING, 0x804e2c0)      = -1 ENODEV (No such device)
> > Please try this patch.
> Yes, that fixes it! Thanks!

Fixed in Linus' tree now. Thanks,

-- 
Jiri Kosina
SUSE Labs

