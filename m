Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXHYKti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXHYKti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762405AbXHYKta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:49:30 -0400
Received: from main.gmane.org ([80.91.229.2]:44973 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbXHYKt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:49:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: USB Key light on/off state depending on mount
Date: Sat, 25 Aug 2007 03:49:12 -0700
Message-ID: <46D00928.1080901@andrew.cmu.edu>
References: <fa.BwCgwGvTNIOD+KEeBrvP11xCEmw@ifi.uio.no> <46CF6791.8040509@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Casey Dahlin <cjdahlin@ncsu.edu>
X-Gmane-NNTP-Posting-Host: c-67-169-182-39.hsd1.ca.comcast.net
User-Agent: Icedove 1.5.0.12 (X11/20070730)
In-Reply-To: <46CF6791.8040509@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Casey Dahlin wrote:
>> Most USB keys nowadays have a small LED somewhere inside of them that 
>> lights up when they are plugged in. On a windows box, the key is lit 
>> up whenever it is mounted, and as soon as it is unmounted it turns 
>> off, giving a handy physical indicator that the key is safe to remove. 
>> On linux, the light is simply on whenever the key is plugged in.
>>
>> Should linux toggle the light depending on mount state? Is it as 
>> trivial as it seems or does this reflect some larger issue?
> 
> I think that Windows turns off power to the port when you do the "safely 
> remove hardware" on it, or something like that. Mount/unmount doesn't 
> really indicate whether the device is in use in Linux, though, since it 
> can still be potentially accessed even when the device isn't mounted.

If there is a way to toggle the power state from userspace, then a 
desktop environment or userland tool can emulate the Windows behavior if 
that is desired.  A lot of devices can charge via USB now, and this is 
actually more convenient on Linux than on Windows (in effect Windows 
requires drivers in order to charge something).  However, having direct 
control over this is useful.

According to the following thread, it appears one can get the needed 
functionality through libusb:
http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19131.html
http://www.gniibe.org/ac-power-by-usb/ac-power-control.html

  - Jim

