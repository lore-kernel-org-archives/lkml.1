Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZETNDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZETNDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZETNDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:03:12 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:47409 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZETNDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TgX4cvqIAwJcjcfdpHCOJJjlo/8YWsBlBZVsls1AxhV3dVMJ1JM0BJBOlyuJ/MvCUB
         MmoKMMv/HJjbypz0v9yVHn1Q0iRUrwj7qV1fNKjSM5h3ZJeoaweTw7JDejzN6RUJrQ0D
         LzSk3AxuFlrGYF69VDp/ELatJ5xLhx2AbNha8=
MIME-Version: 1.0
In-Reply-To: <4A13A034.3080008@pardus.org.tr>
References: <af3ea28a0905170804n500126e4tc425dafd9fcaa68a@mail.gmail.com>
	 <af3ea28a0905192217x2006dbe4gb456217d110b916f@mail.gmail.com>
	 <4A13A034.3080008@pardus.org.tr>
Date: Wed, 20 May 2009 21:03:11 +0800
Message-ID: <af3ea28a0905200603k173b522bj338d50c27118313a@mail.gmail.com>
Subject: Re: fix rtc_cmos bug
From: ye janboe <janboe.ye@gmail.com>
To: =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rjw@sisk.pl, bunk@kernel.org,
       bugme-janitors@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So if register failed, unregister is requested to invoked, right?

Anyway, thank you for your answer.


2009/5/20 Ozan Çaðlayan <ozan@pardus.org.tr>:
> ye janboe wrote On 20-05-2009 08:17:
>> my fix is wrong?
>>
>> Why no one ack this patch?
>>
>> Thanks
>>
>> Janboe
>>
>>
>
> AFAIK any fix in a driver which causes this oops is a partial fix
> because the case should be handled in driver core. This is what the
> patch suggested does actually:
>
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-do-not-oops-when-driver_unregister-is-called-for-unregistered-drivers.patch
>
>
>
