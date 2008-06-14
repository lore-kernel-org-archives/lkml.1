Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYFNHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYFNHoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYFNHoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:44:04 -0400
Received: from stinky.trash.net ([213.144.137.162]:63739 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYFNHoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:44:03 -0400
Message-ID: <48537442.5010506@trash.net>
Date: Sat, 14 Jun 2008 09:33:22 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net> <200806132210.52840.rjw@sisk.pl>
In-Reply-To: <200806132210.52840.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 13 of June 2008, Patrick McHardy wrote:
>   
>> I get this oops once a day, its apparently triggered by something
>> run by cron, but the process is a different one each time.
>>
>> Kernel is -git from yesterday shortly before the -rc6 release
>> (last commit is the usb-2.6 merge, the x86 patches are missing),
>> .config is attached.
>>
>> I'll retry with current -git, but the patches that have gone in
>> since I last updated don't look related.
>>     
>
> Is this a regression from 2.6.25?
>   

I can't really say, I enabled a few new things like lguest.

