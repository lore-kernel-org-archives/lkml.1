Return-Path: <linux-kernel-owner+w=401wt.eu-S935222AbYCFV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222AbYCFV2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYCFV2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:28:24 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:59921 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760263AbYCFV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:28:23 -0500
X-Belgacom-Dynamic: yes
Date: Thu, 6 Mar 2008 22:28:20 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen.Clark@seclark.us, linux-kernel@vger.kernel.org
Subject: Re: iTCO watchdog timer
Message-ID: <20080306212820.GA2866@infomag.infomag.iguana.be>
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304135548.b7b88ee4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Sorry but it's quite busy at the moment...

> > I have new Intel DG33FB mainboard.
> > 
> > 
> > Mar  2 20:47:19 joker1 kernel: iTCO_vendor_support: vendor-support=0
> > Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver 
> > v1.02 (26-Jul-2007)
> > Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Found a ICH9DH TCO device 
> > (Version=2, TCOBASE=0x0460)
> > Mar  2 20:47:19 joker1 kernel: iTCO_wdt: initialized. heartbeat=30 sec 
> > (nowayout=0)
> > ...
> > Mar  4 14:22:59 joker1 kernel: iTCO_wdt: Unexpected close, not stopping 
> > watchdog!
> > 
> > 
> > I start watchdog.c and then kill it expecting the system to reboot - but 
> > it doesn't.
> > 
> > Isn't this how it is supposed to work?

This is indeed how it should work. It's indeed strange that the system doesn't
reboot. If I find some time I will give you some test code to run.

Greetings,
Wim.

