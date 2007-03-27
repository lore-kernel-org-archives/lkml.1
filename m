Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXC0D6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXC0D6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXC0D6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:58:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbXC0D6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:58:48 -0400
Date: Mon, 26 Mar 2007 19:58:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fbdev sysfs imrovements
Message-Id: <20070326195807.184474d7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 14:25:49 +0000 (GMT) James Simmons <jsimmons@infradead.org> wrote:

> This patch does several things to allow the underlying hardware to be 
> shared amount many devices. The most important thing is the use of
> the created device via device_create instead of the hardware device. No 
> longer should fbdev drivers use the xxx_set_drvdata with the parent
> bus device. The second change is having a bus independent power management
> for the framebuffer driver. The final change is using the release method 
> to cleanup the device. The reason again is to make the fbdev driver 
> independent of the bus parent device. Feedback is welcomed.

Causes an early crash on the powermac G5.

http://userweb.kernel.org/~akpm/s5000489.jpg (the oops is the usual powerpc
mess)

config at http://userweb.kernel.org/~akpm/config-g5.txt
