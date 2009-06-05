Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZFEN6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZFEN6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFEN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:58:05 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57019 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZFEN6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gsLrRkfuU6p84wKIrlf1TT0biTqQ7msW11jAOtyUJblkPhLKtqrBCkRohVXue56rOL
         mSBJOoP6xMwI5PjxuOXnZDljYT/g2InALIoHAPkpBkJFQqQlFyKDlRvRbLtQrN0xozNa
         p2RMmCzdRd0vSCAajKHyRvRKgt79dbeCzqbTY=
From: Florian Fainelli <florian@openwrt.org>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: add bcm47xx watchdog driver
Date: Fri, 5 Jun 2009 15:58:01 +0200
User-Agent: KMail/1.9.9
Cc: wim@iguana.be, Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org,
       Aleksandar Radovanovic <biblbroks@sezampro.rs>
References: <4A282D98.6020004@free.fr>
In-Reply-To: <4A282D98.6020004@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906051558.02303.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Matthieu,

Le Thursday 04 June 2009 22:24:56 matthieu castet, vous avez écrit :
> This add watchdog driver for broadcom 47xx device.
> It uses the ssb subsytem to access embeded watchdog device.
>
> Because the watchdog timeout is very short (about 2s), a soft timer is used
> to increase the watchdog period.
>
> Note : A patch for exporting the ssb_watchdog_timer_set will
> be submitted on next linux-mips merge. Without this patch it can't
> be build as a module.

Your driver looks good, could you turn this into a platform device/driver 
instead ? You declare bcm47xx_wdt_platform_device which is unused and you 
also declare a MODULE_ALIAS which suggets it is one.

You are also missing your name in both the header the the MODULE_AUTHOR macro.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
