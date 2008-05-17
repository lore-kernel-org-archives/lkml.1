Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYEQF76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYEQF76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 01:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYEQF7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 01:59:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:19800 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYEQF7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 01:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V2NaKsTAadgX2b0IzX2jfIvqO9NNVyxYtNibH5yvQvIrE3XHLpxO51r7PBhliDw6CfzNg60ezzCr58hnJ5hTqKYS5UpYzH61AvznSf+vrUfK50yb0amhvzGu20Wz63yOiXACxvB0P7z09RiVVedKmLB030FXw3L2a7+YooiwD6o=
Message-ID: <35f686220805162259g18c6bcf9rf87103a98933cc94@mail.gmail.com>
Date: Fri, 16 May 2008 22:59:47 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: tglx@linutronix.de, "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: Kernel hangs in SMP + VMware environment.
Cc: akataria@vmware.com, devzero@web.de, linux-kernel@vger.kernel.org,
       dhecht@vmware.com
In-Reply-To: <200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
	 <200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	 <D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
	 <200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
	 <D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
	 <200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 6:34 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Alok Kataria wrote:
>> > I'm not sure, but this problem might exist in all kernels since 2.6.18 , for
>> > I can find clocksource= parameter in Documentation/kernel-parameters.txt .
>> >
>> Sorry, but I dont understand what you are pointing to, the 2.6.18 kernel does
>> have clocksource parameter.
>> And you are correct this could be a problem with all the kernels which are
>> using clocksource.
>>
>> If you are able to reproduce this with any of the kernels with the patch applied
>> Please let me know.
> I'm not saying "I was able to reproduce this problem after applying your patch".
> I'm saying "All kernels since 2.6.18 might have this problem, and we need to apply
> your patch to all kernels since 2.6.18 if they actually have this problem".
>> >

Thats correct, but I am not sure how the stable folks will pickup these patches.
Thomas, now if we need the patch in any previous  kernels stable tree
(in this instance 2.6.18.x), do we need to backport this patch for
each kernel (which shows this problem)  and send these patches to the
stable tree maintainers or is their some other way  ?
Sorry, but I am not aware of how the stable tree is maintained. Any
information regarding that would be helpful.

Thanks,
Alok

>> > The Ctrl-C didn't work, the Alt-F? didn't work, the Ctrl-Alt-Del didn't work.
>> > I had no time to reproduce it, so I'm not sure it has actually hanged up.
>> >
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
