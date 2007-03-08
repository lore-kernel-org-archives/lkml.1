Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXCHS5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXCHS5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXCHS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:57:22 -0500
Received: from mail.emacinc.com ([63.245.244.68]:53654 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051AbXCHS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:57:21 -0500
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
Date: Thu, 8 Mar 2007 12:57:49 -0600
User-Agent: KMail/1.9.5
Cc: "Ben Nizette" <ben.nizette@iinet.net.au>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
References: <200703061246.29615.ngustavson@emacinc.com> <200703071037.00322.ngustavson@emacinc.com> <1defaf580703081041m5bfbef6t41e911b2dc88667a@mail.gmail.com>
In-Reply-To: <1defaf580703081041m5bfbef6t41e911b2dc88667a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703081257.49651.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: Re: passing function pointers through platform devices?
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4c20386c8d0719b42503efe65abe47ad3fb3d711
> Your mail seems to be about a gpio userspace interface, which is
> something entirely different from an in-kernel API,
Sort of, IMHO sysfs classes seems the logical final incarnation for user space 
access. But to get there it has to migrate down from the machine layer to 
something that declares it's mapping to the pins on a board.
However, just like gpio.txt discusses I am using them to detect MMC insertion, 
so I needed standard way to declare the pin. 
This provides that, thank you.

NZG


