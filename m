Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZBIC0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZBIC0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZBIC0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:26:20 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:39725 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBIC0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:26:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vfc+Edmew1qvJUQ1KJarY9XXXZy7nDdbHjrksklzbwei+i8MHOVlGh+5FMjR5vCCoR
         gkipi68PNsnWPp3EkFPsLZ1VNpn1/Lq3YYbwC87FNzkHR+ObMZv9+177ajsEkpdIHMYw
         +/pe0ByU3+Vr+kuFZ5AtL4GfgGDFS/zj36XpI=
MIME-Version: 1.0
In-Reply-To: <498F5785.3000009@numericable.fr>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.HiF.r20jJB@chimera> <498F5785.3000009@numericable.fr>
Date: Mon, 9 Feb 2009 12:26:18 +1000
Message-ID: <21d7e9970902081826r48777cb8s8c4e882a02575c71@mail.gmail.com>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
From: Dave Airlie <airlied@gmail.com>
To: etienne <etienne.basset@numericable.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 8:07 AM, etienne <etienne.basset@numericable.fr> wrote:
> Rafael J. Wysocki wrote:
>>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12613
>> Subject         : [Suspend regression][DRM, RADEON]
>> Submitter       : etienne <etienne.basset@numericable.fr>
>> Date            : 2009-01-28 22:00 (12 days old)
>> First-Bad-Commit:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
>> References      : http://marc.info/?l=linux-kernel&m=123318030419558&w=4
>>                  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
>>
>>
>>
>
> hello,
> yes it's still present in -rc4
> But I noticed that when I switch off KDE4.2 desktop effects, suspend to ram
> is 100% reliable with 2.6.29-rc4
> With 2.6.28, STR is 100% reliable with or without desktop effects
>

Hi Etienne,

Can you try commenting out the calls to the radeon_suspend and
radeon_resume hooks in radeon_drv.c?

Dave.

> hope this helps,
> Etienne
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
