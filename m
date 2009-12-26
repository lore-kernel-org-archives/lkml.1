Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZLZS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZLZS6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZLZS6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:58:03 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37951 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZLZS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oL4DVLwo6Xm1V0/OOp0ozg5yemGOKNahWjtUOSmM9BN9bWQxLye4Fc6mjTSvla0624
         Zv3y8kHWDPk1tmHicpgNR3r2lZDLxwJSg2DxpB2aiZffQfscx3TpycnQydOIl3Y+0GCW
         oyEkQkWluv56bGhnTyGyNSZ5Q5944OZqPQUBE=
MIME-Version: 1.0
In-Reply-To: <20091225123549.GA26202@gallifrey>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	 <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com>
	 <alpine.LFD.2.00.0912250204220.11466@x200s>
	 <21d7e9970912250232uebe337eu520a7fa98d21c293@mail.gmail.com>
	 <20091225123549.GA26202@gallifrey>
Date: Sat, 26 Dec 2009 13:57:59 -0500
Message-ID: <a728f9f90912261057t1bb2caf9k8c30291ed59b45f6@mail.gmail.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
From: Alex Deucher <alexdeucher@gmail.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Andrei Gaponenko <andrei.gaponenko@cern.ch>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 7:35 AM, Dr. David Alan Gilbert
<linux@treblig.org> wrote:
> * Dave Airlie (airlied@gmail.com) wrote:
>> On Fri, Dec 25, 2009 at 8:08 PM, Andrei Gaponenko
>
> <snip>
>
>> >> Can you wait for a minute or so and see if it continues? though this sounds like
>> >> something different than others have seen.
>> >
>> > I did let it to sit for many minutes during some of iterations of the
>> > bisection; did not notice any progress.
>> >
>> > Andrei
>> >
>> > Please Cc me directly on replies.
>>
>> Did you install the irq firmware from
>> http://people.freedesktop.org/~agd5f/radeon_ucode/
>>
>> I need to add a pointer to the Kconfig (just wasn't there when I sent it i).
>
> I had the same problem (and the same fix); For me it gave up after 60
> seconds of waiting for the firmware and panic'd.
>
> Unfortunately at that point it was still at a VGA display without
> much res, so while I got the backtrace I didn't get the top of the oops.
> (and it was too early for netconsole)
>
> It would be better if the firmware was missing for it just not to do
> modeswitching and carry on; I wonder if it was hangcheck or the like
> that killed it?

Dave's tree already has support for falling back gracefully if any of
the ucode is missing.

Alex
