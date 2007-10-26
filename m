Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXJZSVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXJZSVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763912AbXJZSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:20:39 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61110 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764208AbXJZSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:20:36 -0400
Message-ID: <47222FF1.6050407@lwfinger.net>
Date: Fri, 26 Oct 2007 13:20:33 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
References: <47221E6F.1090607@lwfinger.net> <1193422064.2190.6.camel@lov.site>
In-Reply-To: <1193422064.2190.6.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, 2007-10-26 at 12:05 -0500, Larry Finger wrote:
>> On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1,
>> I get the sysfs rename messages.
> 
> Care to try this? Seems like a silly bug in the core if
> SYSFS_DEPRECATED=y. That's why we didn't catch this earlier, sorry.
> 
> Thanks a lot for the help,
> Kay
> 
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

Yes, that fixed the problem.

Thanks,

Larry
