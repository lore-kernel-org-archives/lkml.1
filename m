Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYINNTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYINNTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYINNTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:19:04 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:60177 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYINNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:19:03 -0400
Message-ID: <41597.166.70.238.43.1221396446.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <alpine.LNX.1.10.0809131932560.16085@fbirervta.pbzchgretzou.qr>
References: <17946.166.70.238.45.1220845139.squirrel@webmail.wolfmountaingroup.com>
    <alpine.LNX.1.10.0809131932560.16085@fbirervta.pbzchgretzou.qr>
Date: Sun, 14 Sep 2008 06:47:26 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's LinuxWare 1.0 MS-DOS Loader
From: jmerkey@wolfmountaingroup.com
To: "Jan Engelhardt" <jengelh@medozas.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Sunday 2008-09-07 23:38, jmerkey@wolfmountaingroup.com wrote:
>
>>I am pleased to announce the release of Merkey's LinuxWare, an MS-DOS (or
>>DR-DOS) loader that allows you to compile a Linux kernel as an MS-DOS
>>Executable, boot and load Linux from MS-DOS (while DOS stays resident).
>>
>>This in essence is exactly the same as old Legacy Netware, and in fact, I
>>wrote a linker that does what the old NetWare custom linker did when it
>>compiled the NetWare kernel and linked it as a DOS Application.  Linux
>>works
>>just like it does normally, except you can quit Linux and exit back to
>> DOS.
>
> So, just another UML architecture ;-)
>
> But how much memory does it need? Raw Linux wants at least 5 MB.
>

This is a good question.  At present, It only reserves 0-1MB for DOS and
the rest of the memory is available for Linux.   It's whatever Linux
wants to use.  One thing it does allow is Linux to call DOS interrupts
from protected mode and return.

I am in process of cleaning up the patch series and prepping it for
2.6.27.  Give me a couple of weeks and I'll post a cleaner version of the
code with the loader debugger, and I'll submit it to Andrew's MM tree as
patches.

Jeff



