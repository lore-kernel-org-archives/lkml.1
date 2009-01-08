Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZAHUdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZAHUdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZAHUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:33:40 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50946 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZAHUdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mtGphpHvbRhsPXEqIIWbJ85uoUzoexmjkaXeWEJ38iIuBddgAB5c4FKLnTAnamISXJ
         29XVMZzWRAIexe0upkk3ybxAMUReyRmTDXC5RQw51DZ6a0hrXfCU1I+tziLw/HqXaRuU
         0lDlcr6OaXYDHiH7Tup/Y1pGbT30gj0V2qgl0=
Message-ID: <5a4c581d0901081233y6b546167sbe3ed9f2ea37f1f9@mail.gmail.com>
Date: Thu, 8 Jan 2009 21:33:35 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading (-git7 is ok)
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <3f9a31f40901072212x41e405fh7e36f6adb927814b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0901070624t6e769966t6b034b14d4732bd@mail.gmail.com>
	 <3f9a31f40901072212x41e405fh7e36f6adb927814b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 7:12 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello alessandro,
>
> On Wed, Jan 7, 2009 at 7:54 PM, Alessandro Suardi
> <alessandro.suardi@gmail.com> wrote:
>>
>> Note that I don't have CONFIG_FIRMWARE_IN_KERNEL, but on
>>  the other hand I didn't earlier, either... and yes, CONFIG_MODULES=y.
>>
>
> Please try with CONFIG_FIRMWARE_IN_KERNEL , is this makes some difference.

Yes it does, thank you - 2.6.28-git11 with CONFIG_FIRMWARE_IN_KERNEL
 gets my tg3 back to work on boot. Must be a requirement since -git8 then ?

Thanks again, ciao,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
