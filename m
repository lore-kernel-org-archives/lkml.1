Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbYCDV4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbYCDV4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYCDV4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:56:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYCDV4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:56:37 -0500
Date: Tue, 4 Mar 2008 13:55:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen.Clark@seclark.us
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: iTCO watchdog timer
Message-Id: <20080304135548.b7b88ee4.akpm@linux-foundation.org>
In-Reply-To: <47CDAC9D.6020505@seclark.us>
References: <47CDAC9D.6020505@seclark.us>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 15:10:05 -0500
Stephen Clark <Stephen.Clark@seclark.us> wrote:

> Hello,
> 
> I have new Intel DG33FB mainboard.
> 
> 
> Mar  2 20:47:19 joker1 kernel: iTCO_vendor_support: vendor-support=0
> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver 
> v1.02 (26-Jul-2007)
> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Found a ICH9DH TCO device 
> (Version=2, TCOBASE=0x0460)
> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: initialized. heartbeat=30 sec 
> (nowayout=0)
> ...
> Mar  4 14:22:59 joker1 kernel: iTCO_wdt: Unexpected close, not stopping 
> watchdog!
> 
> 
> I start watchdog.c and then kill it expecting the system to reboot - but 
> it doesn't.
> 
> Isn't this how it is supposed to work?
> 
> Linux version 2.6.23.15-137.fc8
> 
> 

(cc Wim)

