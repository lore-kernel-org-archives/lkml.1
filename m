Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXICGAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXICGAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXICGAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:00:12 -0400
Received: from smtp.nokia.com ([131.228.20.173]:20382 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXICGAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:00:10 -0400
Message-ID: <46DBA2DE.9040803@nokia.com>
Date: Mon, 03 Sep 2007 08:59:58 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: michal.k.k.piotrowski@gmail.com
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700
 system
References: <46C9D148.5080505@nokia.com> <46D3AF72.7030701@nokia.com>
In-Reply-To: <46D3AF72.7030701@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2007 05:59:58.0754 (UTC) FILETIME=[A8C11020:01C7EDEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Stefan Becker wrote:
>>
>> while trying to debug a hibernation/rtc_cmos alarm wakeup problem in 
>> 2.6.22 (or later) I noticed that the latest kernel crashes (or gets 
>> stuck sometimes) during boot after the message:
>>
>> SMP alternatives: switching to UP code

Retested with 2.6.23-rc4. Same result.

I also added "debug" to the boot command line. Unfortunately it didn't 
show anything new. Comparing to 2.6.22.2 boot the next message should be

  Freeing SMP alternatives: ....

Any hints what I should change on the command line or config to reveal 
more information?

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
