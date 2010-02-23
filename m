Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0BWLht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 06:37:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52533 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0BWLhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 06:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ddQxBl9qiByEIiOA5SnXNazWTN5BjIoRmpmNzz6tbz1BvhumLcpaZ9wFnPlBueOIM2
         iNLpGpTgRnNZkQinW5REGrfaoxHAkUcuqSwPccHXBGNtTVapn7gSqQpepYn59U3Lntuq
         UErY2iv6QygP2hA9KDRmHrwBMozT+te0Ky0jw=
MIME-Version: 1.0
In-Reply-To: <20100223095025.GA18559@liondog.tnic>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
	 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
	 <20100223065953.GB32503@liondog.tnic>
	 <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
	 <20100223095025.GA18559@liondog.tnic>
Date: Tue, 23 Feb 2010 17:07:47 +0530
Message-ID: <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
Subject: Re: QUERY: Inclusion of header files in kernel header files
From: viresh kumar <viresh.linux@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>,
       viresh kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think, ideally including any header file shouldn't give compilation
>> errors for types used in
>> included header file.
>
> Agreed.
>
> I'd send a patch fixing the bus.h header, in case no one has a valid
> technical reason against it.
>

That will be great!!!

Actually this issue is not present only in bus.h, but some other
kernel header files.
Like: arch/arm/include/asm/clkdev.h don't include list.h file but
using struct list_head

May be we need to check this in other header files also.

regards,
viresh kumar
