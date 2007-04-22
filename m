Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXDVBeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXDVBeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 21:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXDVBeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 21:34:13 -0400
Received: from web36709.mail.mud.yahoo.com ([209.191.85.43]:32698 "HELO
	web36709.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753957AbXDVBeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 21:34:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IBb6N+f/QVUWQFaJ5VzXyc+k5PV56Kbo1TwkpEOMa2Uf+qSU5gbN9ZMATV/tLABoA8MObQPVPnqSVyaYrBdY4J0ZIhwn7OQRyVYfeo93dwbK5+CHCXDzKmv9ZPAyjMkFcG7hqUnGANIowgPTYZdZyh8/quw8dpZ5oGYexQwayn4=  ;
Message-ID: <20070422013411.45105.qmail@web36709.mail.mud.yahoo.com>
X-YMail-OSG: QRTkIcQVM1nWi9yBc6zsrSOeA4cQr64b8oXkE8jNoeFz.nhe_ZejE_XUTgxTbYKVtw--
Date: Sat, 21 Apr 2007 18:34:11 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4627D402.8020107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Finally, tifm_sd module needs to be manually inserted.

By the way, the driver emits custom uevent when the new card is detected. I was going to look at
this some day in the future, but if you want to mess a little with hotplug scripts the issue can
be easily solved.

As I already said before, many of the complications exist because this is  an universal adapter,
and memorystick support is quite near in the queue. A good hotplug script will, therefore, look at
the "TIFM_CARD_TYPE" event var and load the appropriate media driver.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
