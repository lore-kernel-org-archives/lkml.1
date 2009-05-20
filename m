Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZETGOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZETGOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZETGOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:14:24 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:53588 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751009AbZETGOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:14:23 -0400
Message-ID: <4A13A034.3080008@pardus.org.tr>
Date: Wed, 20 May 2009 09:16:20 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (X11/20071115)
MIME-Version: 1.0
To: ye janboe <janboe.ye@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, rjw@sisk.pl, bunk@kernel.org,
       bugme-janitors@lists.osdl.org
Subject: Re: fix rtc_cmos bug
References: <af3ea28a0905170804n500126e4tc425dafd9fcaa68a@mail.gmail.com> <af3ea28a0905192217x2006dbe4gb456217d110b916f@mail.gmail.com>
In-Reply-To: <af3ea28a0905192217x2006dbe4gb456217d110b916f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ye janboe wrote On 20-05-2009 08:17:
> my fix is wrong?
>
> Why no one ack this patch?
>
> Thanks
>
> Janboe
>
>   

AFAIK any fix in a driver which causes this oops is a partial fix
because the case should be handled in driver core. This is what the
patch suggested does actually:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-do-not-oops-when-driver_unregister-is-called-for-unregistered-drivers.patch


