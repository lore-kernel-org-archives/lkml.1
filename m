Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZLYKcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZLYKcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLYKcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:32:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42758 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZLYKcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZByINrYLAvLa1IHA21sfHFKOoIpC8uaup8yhhdRHhNmaWRbx1446QYLQC/m3CxrwoG
         qVr3rlbmalKSb00EOBywOlQAiDrE/zYK1DjckMVPArA5bqA3oC+y6pzkwEf5frPFfuZG
         zBBRCCN8In0hngYiOnw2CIMk6FKOXL40T9izA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912250204220.11466@x200s>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	 <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com>
	 <alpine.LFD.2.00.0912250204220.11466@x200s>
Date: Fri, 25 Dec 2009 20:32:08 +1000
Message-ID: <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
From: Dave Airlie <airlied@gmail.com>
To: Andrei Gaponenko <andrei.gaponenko@cern.ch>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 8:08 PM, Andrei Gaponenko
<andrei.gaponenko@cern.ch> wrote:
> On Fri, 25 Dec 2009, Dave Airlie wrote:
>
>> On Fri, Dec 25, 2009 at 7:31 PM, Andrei Gaponenko
>> <andrei.gaponenko@cern.ch> wrote:
>> > Hello,
>> >
>> > One of my systems works fine with 2.6.32, but hangs when trying to
>> > boot 2.6.33-rc2.  Git bisect says
>> > 7923c615b811945a9d9f456c92a7a32c34167458 is the first bad commit:
>> > [...]
>>
>> Can you wait for a minute or so and see if it continues? though this sounds like
>> something different than others have seen.
>
> I did let it to sit for many minutes during some of iterations of the
> bisection; did not notice any progress.
>
> Andrei
>
> Please Cc me directly on replies.

Did you install the irq firmware from
http://people.freedesktop.org/~agd5f/radeon_ucode/

I need to add a pointer to the Kconfig (just wasn't there when I sent it i).

Dave.
