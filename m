Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYJPVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYJPVAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYJPVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:00:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbYJPVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:00:03 -0400
Date: Thu, 16 Oct 2008 13:58:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=FCri?= Reitel <juri.reitel@liewenthal.ee>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Jean Delvare <khali@linux-fr.org>, Rodolfo Giometti <giometti@linux.it>,
       rtc-linux@googlegroups.com
Subject: Re: invalid default values in RTC chip
Message-Id: <20081016135846.8b06d9f8.akpm@linux-foundation.org>
In-Reply-To: <48F45FA5.6040308@liewenthal.ee>
References: <48F45FA5.6040308@liewenthal.ee>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 12:00:21 +0300
J__ri Reitel <juri.reitel@liewenthal.ee> wrote:

> Hi,
> 
> My question relates to RTC driver linux/drivers/rtc/rtc-ds1307.c for 
> device m41t00. Driver probe function will fail if some of the chip's 
> registers contain invalid date time values i.e. if month register is 32 
> or minutes is 61. Is this correct behavior? Probe function's purpose is 
> to check if the device is as was assumed (this time RTC and it is). The 
> chip's values are incorrect but the chip works, even the m41t00 chip 
> manual states that after initial powerup (RTC battery power applied) 
> internal registers will contain random data.
> 
> There are two solutions first is driver patch and another is i2c-dev and 
> i2cset tool to use from user space during bootup. Whitch one should be used?
> 

(cc's added)
