Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYHBEOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYHBEOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 00:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYHBEOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 00:14:16 -0400
Received: from [116.90.133.99] ([116.90.133.99]:60356 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYHBEOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 00:14:16 -0400
Subject: Re: [2.6.27-rc1] Can't connect to encrypted network
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4893DC52.9060203@gawab.com>
References: <4893DC52.9060203@gawab.com>
Content-Type: text/plain
Organization: Amiton Ltd
Date: Sat, 02 Aug 2008 16:14:23 +1200
Message-Id: <1217650463.3619.19.camel@luna.unix.geek.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 21:02 -0700, Justin Madru wrote:
> When I use the 2.6.27-rc1 kernel I can't connect to an encrypted 
> network; the connection times out. Connecting to unencrypted works fine.
> If I use my distro's kernel (2.6.24) or my build 2.6.26 kernel it is 
> able to connect. I'm using Ubuntu 8.4 and an intel 3945 card.
> Am I doing something wrong? or is this a regression? I get the following 
> in my syslog:
[snip]

there is almost nothing useful in that log dump :)

can you please show the relevent bits of dmesg when trying to connect to
the encrypted network

also it would probably be a good idea to try connecting using iwconfig
or wpa_supplicant (for wep or wpa) directly rather than using
networkmanager

-jasper

