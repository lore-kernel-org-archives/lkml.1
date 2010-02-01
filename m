Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0BAEZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:25:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:32913 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0BAEZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:25:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Felix Fietkau <nbd@openwrt.org>
Subject: Re: Forward porting 2.4 driver
Date: Mon, 1 Feb 2010 02:05:33 +0000 (UTC)
Message-ID: <loom.20100201T025725-124@post.gmane.org>
References: <4B634540.9070306@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 93.220.94.193 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.7) Gecko/20091221 Firefox/3.5.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru <jdm64 <at> gawab.com> writes:

> I have this Belkin router with the default firmware running 2.4.30. 
> Belkin provided the source code as specified by the GPL. I was wondering 
> how hard it would be to upgrade the kernel from 2.4.30 to 2.4.37.7. I 
> know that 2.6 would be extremely hard because the driver model has 
> changed so much. But, what changes happened between .30 and .37 that 
> would make it difficult to upgrade the code? Did the driver model or 
> other drastic changes happen? Could I just do a file diff; import the 
> new files Belkin added and update the make files and kconfig?
> 
> The CPU and wireless card are based on the Ralink 2880/2860 or something 
> like that.
Support for these chips is being worked on in the OpenWrt project.
We have some work in progress code based on Linux 2.6.32. It will be submitted
upstream when it's complete. Feel free to help us complete it, if you want to ;)
I know the code that Ralink provides for these chips, and I'd say any time spent
on changing it or using it for any purpose other than deriving hardware
information is a complete waste of time.

- Felix

