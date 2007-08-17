Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbXHQPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbXHQPXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXHQPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:23:09 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:21617 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755045AbXHQPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:23:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rwWLQtpnbWTehLcnSa936EUyrKSZfyGv6RKGdxFS6ITZsAJOhb2ipL3zqF/VKJcWsDjISJi3rsWfhbZl7VW+yqrdJ91N/taTBz1z53+OqpKz6YEXblnsusuS36AYqsi47Uxuaip1HyWpTi2m5bCi3ED7Y8jB19p8bbqQMQwVraw=  ;
X-YMail-OSG: WPg3qUQVM1kQRrhWhoc.l5c5xCMqzAwVXWW8D4GkYZlDwulAlVSxiyh6gZT8VXfbHGccfkUOJYaildmytk5wdXJDzg51GxEtAb9MdXTazx6biki9c5czb_RXsCqmYRLs5bRIaAPcdaG.PpQ-
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 08:23:15 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net
References: <20070817.010638.24337787.anemo@mba.ocn.ne.jp> <Pine.LNX.4.64.0708171258360.5492@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708171258360.5492@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170823.15894.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Jan Engelhardt wrote:
> On Aug 17 2007 01:06, Atsushi Nemoto wrote:
> >Add an MODULE_ALIAS() to make this platform driver hotplug-aware.
> >
> >...
> >+MODULE_ALIAS("ds1742");
> 
> Why exactly is this needed? What script refers to the module as ds1742 instead
> of rtc-ds1742? Regular hotplug (e.g. udev/modprobe) also go by PCI ID or
> whatever is applicable and load the module which provides support for said ID.

Most busses don't have managed device IDs like PCI, USB, or PNP.

The platform, spi, and i2c busses use the driver name, which is
obviously managed within the scope of all Linux drivers.

- Dave
