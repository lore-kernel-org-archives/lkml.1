Return-Path: <linux-kernel-owner+w=401wt.eu-S1765225AbXHQQCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765225AbXHQQCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXHQQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:02:06 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:35559 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751337AbXHQQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:02:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q/4yB8u4UJ7lvcpUs1ec548VP5MQy3sNzcS9MxJxQyjIeelTsdYU2ZQclJtPcdqHtcDw8ur/exkDgVipsTedCzZu+plixThsKl7A3S87KeOPcsNTKOR9luDSx8Jv3lI06dc49yzTTq9l0ScFYghdbjs9WDSVnlE/jXqD/wI/xB8=  ;
X-YMail-OSG: EKGDzTUVM1nhpQqPVIi.oLg4EKczINVDjH9QdIHEIkWVfoDIhChB1efVBvKf2uOPuCh2ba.M8A--
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 09:02:00 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
References: <20070817.010638.24337787.anemo@mba.ocn.ne.jp> <200708170823.15894.david-b@pacbell.net> <Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170902.01260.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Jan Engelhardt wrote:
> >Most busses don't have managed device IDs like PCI, USB, or PNP.
> >
> >The platform, spi, and i2c busses use the driver name, which is
> >obviously managed within the scope of all Linux drivers.
> >
> Yeah but that does not tell me why it needs the ds1742 alias
> if scripts (whatever they use to discover it) could modprobe rtc-ds1742
> instead.

Because for some reason the driver name isn't rtc-ds1742 ...

My preferred style for such patches puts the MODULE_ALIAS up
near the strange driver name, so it's more clear what's going
on.  Putting all the MODULE_*() stuff at the end of the file
gets confusing in this case.

