Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXE0MvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXE0MvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXE0MvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:51:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:48270 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXE0MvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:51:07 -0400
Message-ID: <46597F37.5050107@tmr.com>
Date: Sun, 27 May 2007 08:53:11 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Documentation on /sys/power/resume
References: <4658C807.9040005@tmr.com> <200705271253.03396.rjw@sisk.pl>
In-Reply-To: <200705271253.03396.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Hi,
> 
> On Sunday, 27 May 2007 01:51, Bill Davidsen wrote:
>> Not in the ABI doc, is there and doc at all, and if not could someone 
>> who knows where it's used might give me a hint, as a quick look didn't 
>> bring enlightenment. Or is it a future hook which doesn't work yet?
> 
> That's something that in theory may allow you to resume the system from
> and initrd script.
> 
> Basically, you write your resume device's major and minor numbers
> into it as the "MAJ:MIN" string (eg. "8:3" for /dev/sda3 on my box) and the
> kernel will try to read the image from this device and restore it.
> 
> It only works with partitions and the use of it us discouraged, so it's
> deliberately undocumented.
> 
Thanks, that's just different enough from what little info I had to make 
what I have not work. I'm looking at resume from a non-swap location.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
