Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbXCBJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbXCBJ0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXCBJ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:26:33 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64615 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933295AbXCBJ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:26:32 -0500
Date: Fri, 2 Mar 2007 10:26:17 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>,
       Milan Svoboda <msvoboda@ra.rockwell.com>
Subject: Re: [patch 2.6.20-rc2] gpio_direction_output() needs an initial
 value
Message-ID: <20070302102617.2fb8e0dc@dhcp-252-105.norway.atmel.com>
In-Reply-To: <200703011825.10370.david-b@pacbell.net>
References: <200703011825.10370.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 18:25:09 -0800
David Brownell <david-b@pacbell.net> wrote:

> It's been pointed out that output GPIOs should have an initial value, to
> avoid signal glitching ... among other things, it can be some time before
> a driver is ready.  This patch corrects that oversight, fixing
> 
>  - documentation
>  - platforms supporting the GPIO interface
>  - users of that call (just one for now, others are pending)
> 
> Note that most platforms are clear about the hardware letting the output
> value be set before the pin direction is changed, but the s3c241x docs
> are vague on that topic ... so those chips might not avoid the glitches.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Thanks, Dave.

Haavard
