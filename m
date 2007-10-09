Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbXJIStG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbXJIStG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXJISsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:48:53 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25908 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbXJISsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:48:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Hkn0AdcJzzGbU+KdtYD08cCAAf3zz+dO7JMdxQaLvtwOoutgAHdPJ9IfNhVlp6WMFUNJEmONyo1NTdb5Vf1zuF8bz0Ru0y7IF5nm2oNHxXvQvGFpgriSOWL5obxhX/shwrLQMXWHcAMrKawqI1CFQzBrmI2YVLs/ZHmxuomr/9k=  ;
X-YMail-OSG: xojG5jsVM1msBkSBXhf4e6ZDkeN8NRqSh.P2elD5BYcteYWv1T7LXW45Rzy7FzqMthjfnIO3rw--
Date: Tue, 09 Oct 2007 11:48:51 -0700
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com, davem@davemloft.net
References: <20071009031049.GD14127@kroah.com>
 <20071008.201653.43030513.davem@davemloft.net>
 <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.204236.92016616.davem@davemloft.net>
 <20071009043909.GA4940@kroah.com>
 <20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <1191912184.6355.66.camel@pasglop>
In-Reply-To: <1191912184.6355.66.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009184850.33F8D236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Assuming PCI is present, /sys/bus/pci/devices/*/class can tell
> > if EHCI is present (0x0c0320) ... if so, load that driver.
> > Then repeat for OHCI (0x0c0310) and UHCI (0x0c0300).
>
> That will not work for all of the non-PCI implementations though.

Oddly enough, that's why I said "assuming PCI is present".  ;)

Anything using the ARC/TDI RTL doesn't have this issue ... it
includes full/low speed support directly, without a companion
controller.  That covers the Freescale silicon and some others.
For a long time I think that was the only generally available
non-PCI implementation.

But you're right that there are (now) a few other cases.
In-tree right now are also the Au1200, ps3, and 440epx.

- Dave

