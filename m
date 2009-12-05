Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbZLEEqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbZLEEqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 23:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbZLEEqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 23:46:54 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43189 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714AbZLEEqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 23:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ImVkiM0AFH3nc/Gif2TX7VURbkc4iDDSh3TjkhUjC9sBOl3B0rn6a9hfyx3U6KNO/d
         BhdpHM4tK/De9DaA4U7a3H9YIRCTH8dd3Se7XymoI9lZQctAFnZcPR7nHCR/83xVREyw
         UXb2VF8XWhHAXnoOxteOpGSKtJuW63dps0zzY=
MIME-Version: 1.0
In-Reply-To: <4B19B53B.60605@zytor.com>
References: <b9df5fa10912040824r4c496b54x6165523935293001@mail.gmail.com>
	 <4B19B53B.60605@zytor.com>
Date: Sat, 5 Dec 2009 10:47:00 +0600
Message-ID: <b9df5fa10912042047i7b6b84e2n2d2a5441d721b3ca@mail.gmail.com>
Subject: Re: [PATCH] x86: Put trampoline_data into readonly section.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/09, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/04/2009 08:24 AM, Rakib Mullick wrote:
>
>  Perhaps the better thing would be to define trampoline_size as an
>  absolute symbol in arch/x86/kernel/trampoline_*.S, especially since it
>  probably generates bad code to subtract two global symbols like that.
>
But - trampoline_data is placed into - cpu init readonly data section.
And we are
referencing it from non-cpuinit function. ....... so I think the
problem remains.
Isn't it ? Or am I missing anything?

Rakib
>
>         -hpa
>
