Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXBNAgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXBNAgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXBNAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:36:10 -0500
Received: from mail.tmr.com ([64.65.253.246]:42390 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXBNAgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:36:09 -0500
Message-ID: <45D259DD.7040505@tmr.com>
Date: Tue, 13 Feb 2007 19:37:49 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] Can't start MD devices by using /dev/disk/by-id
References: <8d158e1f0702131351l3e3e1ae2u71a13de655391fce@mail.gmail.com>
In-Reply-To: <8d158e1f0702131351l3e3e1ae2u71a13de655391fce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> Hi chaps,
> 
> I just came home, rebooted my box to git8 and *gasp* a problem :)
> 
> I can't start my MD devices anymore by defining /dev/disk/by-id/*
> devices in /etc/mdadm.conf.
> 
> When I do a: mdadm --assemble /dev/md/1 it tells me "No devices found
> for /dev/md/1"
> When I edit the file /etc/mdadm.conf and change the /dev/disk/by-id/*
> to whatever the symbolic links points to in the /dev directory, it
> does work.
> 
Just out of curiosity, why did you do this in such a manual way instead 
of just using the UUID? I would think every time you replace a failed 
drive you would have to go edit the files all over again.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
