Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZFYXj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZFYXj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZFYXjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:39:21 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:46220 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZFYXjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HsYkPH9J+8Zhbbc17gPEmzonBaD7mOfL6U3Y7dORG+vPknqtLSBgh5QtoHYTApuz8V
         6rV7d8mgbzwY/DnoaCh+uEZlF6i28q4nYyUMGpKPB3DLtVR3FN1t7wtB8CwxLTLk+2Yc
         5MG/4QNpinxrKaXZebyRUS8pNO3UITrLzK9Dg=
MIME-Version: 1.0
In-Reply-To: <4A4238D2.2060501@googlemail.com>
References: <alpine.DEB.2.00.0906240723420.18292@skynet.skynet.ie>
	 <1820d69d0906240715v6c3591c4x30ee87e9ec8774f7@mail.gmail.com>
	 <4A4238D2.2060501@googlemail.com>
Date: Fri, 26 Jun 2009 09:31:43 +1000
Message-ID: <21d7e9970906251631h272607d6scee36997a0c574ab@mail.gmail.com>
Subject: Re: [git pull] drm fixes + intel display port
From: Dave Airlie <airlied@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Dave Airlie <airlied@linux.ie>, Ma Ling <ling.ma@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 12:31 AM, Gabriel C<nix.or.die@googlemail.com> wrote:
> [ forgot to CC LKML , sorry ]
>
> Gabriel C wrote:
>
>> 2009/6/24 Dave Airlie <airlied@linux.ie>:
>>> Hi Linus,
>>>
>>> Please pull the 'drm-fixes' branch from
>>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
>>>
>>
>> Hi Dave ,
>>
>> I own an DQ45CB Intel motherboard. When enabling KMS with kernels from
>> 2.6.29* to current git / linux-next on that board
>> I don't get any console. My Monitor is saying 'No signal' , however
>> once X starts up I can login in KDE/gnome etc.
>>
>> The monitor is connected with an DVI-I -> VGA connector.
>>
>> I found on the gfx mailing list the following patch from Ma Ling :
>>
>> http://lists.freedesktop.org/archives/intel-gfx/2009-May/002504.html
>>
>> which seems to fix my problem. With that patch applied I get a console
>> and everything works fine.
>>
>> However I still have such :
>>
>> [   21.205449] i2c-adapter i2c-1: unable to read EDID block.
>> [   21.205452] i915 0000:00:02.0: VGA-1: no EDID data
>>
>>
>> messages in my dmesg but it works.
>>
>>
>> Is there any reason why this patch never got merged ?

I don't think that patch is totally correct, it looks more like a lets
try everything approach, I'll cc more Intel folks and see what they can do.

Dave.

>>
>> Best Regards,
>>
>> Gabriel C
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
