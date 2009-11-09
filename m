Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKIXTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKIXTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZKIXTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:19:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbZKIXTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:19:33 -0500
Date: Mon, 9 Nov 2009 15:18:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [patch] added brightness feature to lcd class.
Message-Id: <20091109151836.4a6b294d.akpm@linux-foundation.org>
In-Reply-To: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 17:50:02 +0900
InKi Dae <daeinki@gmail.com> wrote:

> This patch adds brightness feature to lcd class.
> (kernel/driver/video/backlight/lcd.c)
> 
> In the past, most of the lcd panels for embedded system was TFT-LCD
> Panel needing backlight device.
> But now AMOLED LCD Panel appeared so we should consider brightness
> control for AMOLED Panel.
> 
> For the time being, I used backlight fake driver for brightness
> control of AMOLED LCD Panel.
> But this way is not good, so I propose to add brightness feature to lcd class.
> 
> For this, I attached patch file and if my proposal is approved
> Then I will send s6e63m0 and tl2796 AMOLED lcd panel driver based on
> lcd class modified soon.

Please send the s6e63m0 and tl2796 patches anyway.  That way we have
some examples of how this new capability is used by drivers.

