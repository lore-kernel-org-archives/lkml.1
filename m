Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZDRIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZDRIKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZDRIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:09:58 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:46404 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZDRIJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:09:57 -0400
Message-ID: <49E98AD2.8060601@msgid.tls.msk.ru>
Date: Sat, 18 Apr 2009 12:09:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de>
In-Reply-To: <200904180946.27722.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prakash Punnoor wrote:
> Hi,
> 
> as I am using only RAID5 I wonder why the RAID6 code also needs to be built.
> Here is a rough patch of making RAID6 optional (but depending on raid456)
> without reording of functions to minimize ifdef scattering.
> (I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
> It would probably be nicer to make RAID4/5 and RAID6 independently selectable
> of each other. But that requires more refactoring, as I can see.

Hm.  In "old good days" there were 3 independent kernel modules,
named raid4, raid5 and raid6.  Later on, they got merged into one
since they share quite alot of the code, and has only a few specific
parts.  Now you're trying to separate them back somewhat....

What's your goal?  What's the problem you're trying to solve?

/mjt
