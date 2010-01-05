Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323Ab0AEWrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0AEWrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953Ab0AEWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:47:11 -0500
Received: from mail.tmr.com ([64.65.253.246]:33190 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0AEWrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:47:09 -0500
Message-ID: <4B43C169.3040601@tmr.com>
Date: Tue, 05 Jan 2010 17:47:05 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33 fails to find cpu firmware
References: <201001050128.12202.gene.heskett@verizon.net>
In-Reply-To: <201001050128.12202.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings a;;
> 
> 2.6.33-rc2 isn't terribly stable here, but the first problem is .6 seconds 
> into the boot, it hangs for 1 minute waiting on the amd cpu firmware, which I 
> don't believe it ever finds, it just times out and goes on.  This machine 
> runs fairly well without that even for a cold boot.
> 
> I assume this is because the root filesystem with /lib/firmware is not yet 
> available, and that if this file was supplied in the initrd file, this would 
> go away.
> 
> I've studied the manpage for mkinitrd, but the precise option to do this 
> preload escapes me.
> 
But the root should be mounted before firmware, I'm looking at my messages log 
and everything including swap seems to be there before the firmware loader is 
called. That's on a 2.6.31 kernel, but still...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
