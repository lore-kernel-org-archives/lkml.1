Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZAYVB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZAYVB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZAYVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:01:17 -0500
Received: from main.gmane.org ([80.91.229.2]:33958 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZAYVBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:01:16 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
Date: Sun, 25 Jan 2009 16:01:01 -0500
Message-ID: <497CD30D.80203@tmr.com>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com> <20090125204603.2ccb5169@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: kernel-testers@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 pango-text SeaMonkey/1.1.14
In-Reply-To: <20090125204603.2ccb5169@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 26 Jan 2009 02:09:56 +0530
> Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> 
>> Hello all,
>>
>> I added extra IDE drive I get similar messages like below so I replace
>> it another drive but I am still getting similar error messages on
>> 2.6.29-rc2-tip:
>>
>> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
>> hdb: status error: error=0x40 <3>{ UncorrectableError },
>> LBAsect=208845, sector=0
> 
> Uncorrectable Error is an error from the drive, not the kernel. Looks
> like you have bad sectors on that drive.
> 
He noted that he tried another drive, so unless he has a pile of bad drives it's 
probably something else. Being "hdb" may indicate that it's connected to the 
same controller as "hda" and might not be jumpered for slave. Or it might be a 
bad cable, a controller which doesn't like two drives, a dubious power 
connector, etc. Or if he doesn't have an hda, perhaps the kernel doesn't like a 
secondary drive without a primary.

Being hdb instead of sdb with a new kernel indicates he is using a config which 
may get a lot less testing these days, perhaps?

In any case, I doubt he had two bad drives, so something else is more likely.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

