Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXBVKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXBVKaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbXBVKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:30:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43296
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932132AbXBVKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:30:29 -0500
Date: Thu, 22 Feb 2007 02:30:28 -0800 (PST)
Message-Id: <20070222.023028.74743752.davem@davemloft.net>
To: al@alarsen.net
Cc: greg@kroah.com, hirofumi@mail.parknet.co.jp, yoshfuji@linux-ipv6.org,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux
 2.6.21-rc1)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172138267l.24074l.0l@ecxwww1.reanet.de>
References: <87abz75hzs.fsf@duaron.myhome.or.jp>
	<20070222001809.GB30444@kroah.com>
	<1172138267l.24074l.0l@ecxwww1.reanet.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Larsen <al@alarsen.net>
Date: Thu, 22 Feb 2007 10:57:47 +0100

> On 2007-02-22 01:18:09, Greg KH wrote:
> > On Thu, Feb 22, 2007 at 06:16:23AM +0900, OGAWA Hirofumi wrote:
> > > E.g. something calls the request_modle(), and if hotplug is using
> > > socket(PF_UNIX) and af_unix is module, it also calls request_modle()?
> > > 
> > > Just my guess though...
> > 
> > Ugh, why does anyone make af_unix a module these days.  I thought only
> > Debian was that foolish...  :)
> 
> Then how about making CONFIG_UNIX bool instead of tristate?

Please see the archives, there have been discussions about this
kind of suggestion before.

We should not dis-allow AF_UNIX being modular just because it
now becomes inconvenient.

