Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYKRX4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYKRX4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYKRX4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:56:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:49475 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYKRX4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=ulKiCQItd49ktxLkLgB2LXquf9j+Vwpc2xLg+J/D/W10HZrFP/tm+FoeF/TJB0HwXk
         gsUKL0tw0CjgpR8ZGvomlYvYNxDeut4JaifULQB0o6CdNaUCtBPDIR/zANwt+XkNZTHJ
         AdjjVJA3NeDZO7w+w9IxzjzRtDPa9cPxsWfqQ=
From: Grant Coady <gcoady.lk@gmail.com>
To: Eric Sandall <eric@sandall.us>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.27.6
Date: Wed, 19 Nov 2008 10:56:11 +1100
Organization: scattered
Message-ID: <8dl6i41eobduef8djn8bj7d1sih07tga47@4ax.com>
References: <20081113185350.GA3765@kroah.com> <20081118092051.53d1fcc2@sandall.us>
In-Reply-To: <20081118092051.53d1fcc2@sandall.us>
X-Mailer: Forte Agent 4.2/32.1118
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 09:20:51 -0800, you wrote:

>On Thu, 13 Nov 2008 10:53:50 -0800
>Greg KH <gregkh@suse.de> wrote:
>> We (the -stable team) are announcing the release of the 2.6.27.6
>> kernel.
>> 
>> It contains a wide range of bugfixes, and all users of the 2.6.27
>> kernel series are strongly encouraged to upgrade.
>> 
>> I'll also be replying to this message with a copy of the patch between
>> 2.6.27.5 and 2.6.27.6
>> Francois Romieu (3):
>>       r8169: get ethtool settings through the generic mii helper
>>       r8169: fix RxMissed register access
>>       r8169: wake up the PHY of the 8168
>
>My r8169 no longer compiles:
>...
>  Building modules, stage 2.
>  MODPOST 243 modules
>ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
>make[1]: *** [__modpost] Error 1
>make: *** [modules] Error 2
>
>Attached my .config. Also tried witht he following changed, with the
>same results:
>+CONFIG_NET_ETHERNET=y
>+CONFIG_MII=m

r8169 works fine here, from dmesg:

r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:04:00.0: setting latency timer to 64
eth0: RTL8168b/8111b at 0xffffc200100b8000, 00:1d:7d:03:5e:98, XID 38000000 IRQ 378
...
r8169: eth0: link up

See: http://bugsplatter.id.au/kernel/boxen/pooh64/ for dmesg + config

Grant.
-- 
http://bugsplatter.id.au
