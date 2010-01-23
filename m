Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0AWLWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0AWLWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222Ab0AWLWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:22:12 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:57903 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0AWLWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cWFIvU4gwXgOezSzETBAzPpuoeKDbGwW9s+oQcNT//yw2C5LHe3gOBL7Fc5ksuZRKM
         ju/5sBJdfKA22KJqKo77XZfAjadthdZeUe+reu0NYD5FwvkYqMuJ37QieqzGPeYX9KuP
         k0x3wb7j64SXSEHXU9gpXgqPqFHSXN44aZLeE=
MIME-Version: 1.0
In-Reply-To: <4B5AD2C3.4020409@pardus.org.tr>
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com>
	 <4B5AD2C3.4020409@pardus.org.tr>
Date: Sat, 23 Jan 2010 22:22:10 +1100
Message-ID: <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com>
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
From: Nathan Williams <ngwilliams@gmail.com>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/23 Ozan Çağlayan <ozan@pardus.org.tr>:
> Nathan Williams wrote:
>> I'm having trouble with my PC crashing just as it's attempting to power off.
>> I managed to git bisect to this commit:
>>
>
> http://bugzilla.kernel.org/show_bug.cgi?id=15037
> http://patchwork.kernel.org/patch/71537/
>

Thanks. The patch works for me.
