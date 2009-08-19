Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZHST07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZHST07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZHST06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:26:58 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64332 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZHST05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=xCgoODp8VpKaqcf6gbIVcCvgHmVHc/LL5c7p6pmXuWaxaNQj7Yf1nqi7kHNSXOzssV
         BJdNZHlCx5fzskiG7ZNr5P/NKuCozkecQlH3FG1bGb9e/o7KvzccvDOqMdhRwMKB77CM
         a3Q7iMi1uvjjHY/WzrW7AFIk91AyDlxFWV03M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/22] Staging: rt{286,287,307}0: various fixes/cleanups
Date: Wed, 19 Aug 2009 21:25:59 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-dirty; KDE/4.2.4; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain> <1250480865.7243.15.camel@marge.simson.net>
In-Reply-To: <1250480865.7243.15.camel@marge.simson.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908192125.59395.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 August 2009 05:47:45 Mike Galbraith wrote:
> On Sun, 2009-08-16 at 21:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > Some fixes, some cleanups and a lot of preparations for finally merging
> > rt{28,30}70 drivers together.
> > 
> > Tested with RT2860 (Asus Eee 901) and RT3070 (el cheapo USB dongle that
> > I've bought recently to speed up the development, I'm posting this mail
> > using it right now) chipsets.
> 
> I plugged these into tip this morning (3, 5 and 21 needed hammering) and
> tried my box's onboard USB gizmo:
> 
> Bus 007 Device 003: ID 13d3:3247 IMC Networks 802.11 n/g/b Wireless LAN Adapter
> 
> Works fine here.

Thanks a lot for extra testing, could you also check what MAC version is
this beast using?  I'm now working on merging rt2870 and rt3070 together,
and I would need somebody with 2870 flavor to verify the end result.. :)

The USB dongle that I'm doing tests with is:

	Bus 004 Device 003: ID 148f:3070 Ralink Technology, Corp.

and is identified by rt2800usb as 3070 flavor:

	phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0005, rev: 30700200.

> > PS I tried using rt2800usb driver found in 2.6.31-rc6 (with overdue fix
> > for memory corruption in rf cache from Pavel Roskin) for RT3070 chipset
> > but it doesn't seem to work yet (iwlist wlan0 scan => no stations)..
> 
> Yeah, I can ping/traceroute with it, but that's about it, seems to choke
> as soon as you need to xfer non-dinky packets.  (I would have thought
> that the corruption fix would swim upstream given it's utterly deadly)

It it in upstream now, a bit of competition (even if the end goal is
exactly the same) is never a bad thing.. ;)
