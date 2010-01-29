Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897Ab0A2Ug0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0A2Ug0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601Ab0A2Ug0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:36:26 -0500
Received: from 1wt.eu ([62.212.114.60]:55131 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0A2UgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:36:25 -0500
Date: Fri, 29 Jan 2010 21:36:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Forward porting 2.4 driver
Message-ID: <20100129203613.GF27907@1wt.eu>
References: <4B634540.9070306@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B634540.9070306@gawab.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 29, 2010 at 12:29:52PM -0800, Justin Madru wrote:
> I have this Belkin router with the default firmware running 2.4.30. 
> Belkin provided the source code as specified by the GPL. I was wondering 
> how hard it would be to upgrade the kernel from 2.4.30 to 2.4.37.7. I 
> know that 2.6 would be extremely hard because the driver model has 
> changed so much. But, what changes happened between .30 and .37 that 
> would make it difficult to upgrade the code? Did the driver model or 
> other drastic changes happen? Could I just do a file diff; import the 
> new files Belkin added and update the make files and kconfig?

it will very likely work even without any change. I have some drivers
in my private tree which were written for various versions between
2.4.23 and 2.4.33, most of which apply without problem. In general
the only conflicts you can get are in Config.in or the makefiles
where the patch wants to add one line to enable the driver, because
the context might have changed. But that's really obvious to fix.

> The CPU and wireless card are based on the Ralink 2880/2860 or something 
> like that.

Well, if you have the 2.4 driver and the hardware, it could also be
a nice exercise to try to port it to 2.6. It's not necessarily that
much complicated, as there are several drivers which are compatible
with both 2.4 and 2.6. They generally rely on some #define to rename
some struct members or use different macros depending on versions.

Regards,
Willy

