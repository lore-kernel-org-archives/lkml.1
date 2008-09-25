Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYIYG3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYIYG3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYIYG3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:29:36 -0400
Received: from mail.agmk.net ([91.192.224.71]:21495 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYIYG3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:29:35 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Date: Thu, 25 Sep 2008 08:29:22 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <20080925024840.GA14575@kroah.com>
In-Reply-To: <20080925024840.GA14575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809250829.22294.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 of September 2008 04:48:40 Greg KH wrote:
> On Wed, Sep 24, 2008 at 05:07:59PM +0200, Paweł Sikora wrote:
> > Hi All,
> >
> > with out-of-tree kernel modules we (users and linux distributions)
> > have a problem - with every frequent kernel release we need
> > to rebuild them all due to vermagic and possible abi changes.
> > this leads to lot of useless work (bumping rpm specs releases,
> > preparing rpm packages and so on).
>
> "we" are working hard to remove any and all barriers for modules to be
> out-of-tree.  See the recent drivers/staging/ announcement, I can now
> take pretty much any code that at least builds and works for someone,
> and get it into the kernel tree where it can be properly cleaned up and
> cared for over time before it moves to the "correct" location within the
> kernel.
>
> What kernel modules do you currently use/rely on that are not in the
> main kernel tree?  Do you have links to them?  I'd be glad to add them.

here's a quick list:

- http://www.lirc.org
- http://sourceforge.net/projects/bluetooth-alsa
- http://rt2x00.serialmonkey.com
- http://www.unav-micro.com/Drivers.aspx -> AR81Family-linux-v1.0.1.0.tar.gz
  (e.g. asus-p5q-pro m/b has such ethernet port, pciid=1969:1026)
- http://aufs.sourceforge.net
- http://linux-uvc.berlios.de
- http://www.misdn.org
- toshiba bluetooth module [http://0bits.com/toshbt/toshbt-1.0.tar.gz]
- zaptel telephony driver [http://www.asterisk.org]
  with firmware [http://downloads.digium.com/pub/telephony/firmware/releases]
