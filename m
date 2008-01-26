Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYAZLpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYAZLpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYAZLoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:44:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42210 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYAZLox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:44:53 -0500
Message-ID: <479B1D30.20501@garzik.org>
Date: Sat, 26 Jan 2008 06:44:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126101835.GD20935@hacking>
In-Reply-To: <20080126101835.GD20935@hacking>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> For example, the defination of __devexit_p:
> 
> #if defined(MODULE) || defined(CONFIG_HOTPLUG)
> #define __devexit_p(x) x
> #else
> #define __devexit_p(x) NULL
> #endif
> 
> If !(defined(MODULE) || defined(CONFIG_HOTPLUG)), __devexit_p
> is just a NULL pointer, thus 'x' may be unused although defined.


  ...and that's the purpose of the __devexit marker on the code itself.

	Jeff


