Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZGIDEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZGIDEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZGIDEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:04:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbZGIDEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jXNpVFRTvxhJSaZtpCbkfySPMBOSov+7+EEF9fKw7mJUOTwOmUnnY9kFgr22PZlLpu
         3sZjm+3BgNYrDmCqs+tIixIiBngZ5BCfM6QYMBGqlvzOo5XEizeOhra1hXBXvfz4pFXt
         UxehpUqVTX9K/sO+7NFJ5DJTNt6hvSJRe0k0k=
MIME-Version: 1.0
In-Reply-To: <4A55109C.7040506@zytor.com>
References: <20090708200741.GI5301@lenovo> <4A55109C.7040506@zytor.com>
Date: Thu, 9 Jul 2009 07:04:35 +0400
X-Google-Sender-Auth: e9b57c881c7f01c1
Message-ID: <aa79d98a0907082004i616ff057ic8eea014f712064d@mail.gmail.com>
Subject: Re: [PATCH -tip] x86,apic -- don't forget to disconnect BSP discrete 
	apic
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/09, H. Peter Anvin <hpa@zytor.com> wrote:
> Cyrill Gorcunov wrote:
>> In case of discrete APIC cpu_has_apic could be not set.
>> This leads to disconnect_bsp_APIC is not called where
>> it should.
>
> I thought we were going to turn on cpu_has_apic in this case?
>
> 	-hpa
>
>
Yes, this is just a temporary fix. I'll remove this snippet as only
cpu-has-apic patch will be ready (i need to re-check all ways and and
i need some time for this. Hope will finish it at weekend). Dunno
Peter. If there is no urgency -- lets mark that we have this temporary
workaround in lklm and if we get kind of bugreport we could apply the
patch shortly :)
