Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYKNV0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYKNV0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKNV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:26:27 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37544 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYKNV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:26:26 -0500
Message-ID: <491DECF9.6020707@lwfinger.net>
Date: Fri, 14 Nov 2008 15:26:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org
Subject: Re: Strange behavior since commit 5fef0e5c
References: <491D92EB.2030200@lwfinger.net> <200811142053.05880.bzolnier@gmail.com>
In-Reply-To: <200811142053.05880.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Friday 14 November 2008, Larry Finger wrote:
>> In testing kernel version 2.6.28-rc4 on my server that was running kernel
>> 2.6.27, an external IDE disk system connected via a PCCard interface failed to
>> start because module ide_disk would not load. The console output is as follows:
>>
>> finger@sonylap:~> sudo modprobe -v ide-disk
>> WARNING: module 'ide_gd_mod' is unsupported
>> FATAL: Module ide_disk not found.
> 
> Please verify that your system uses a recent module-init-tools version
> and then repeat 'make modules' + 'make modules_install' (it could be that
> something went wrong previously during installing modules) as it works
> just fine for me with 2.6.28-rc3 and module-init-tools 3.4.

That was the problem. I had 3.3 pre11, which was installed by openSUSE 10.3.
Updating to version 3.4 fixed the problem. Thanks.

Should the requirement in Documentation/Changes be modified, or is that info no
longer used?

Larry
