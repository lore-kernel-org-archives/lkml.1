Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0AONtc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407Ab0AONtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:49:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:62980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0AONtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wp1mSM9zlLog9T/cBfAZqgquoAGiQersz6tXFuIJ9Q9feyrmYBWBm6S+2vT3oR9niw
         IzauYFCNBJcYG6UbAKxrryARFfkhVU+FvLykaGjYaXKN9YmWjzy/E2xaQgPYSIJcmULL
         fNPGf1yflKXd0iC8O5oEI7vkx4P3BfhuXRov8=
MIME-Version: 1.0
In-Reply-To: <1263526556.724.402.camel@pasglop>
References: <201001140059.o0E0x4wS006650@hera.kernel.org>
	 <1263437142.724.320.camel@pasglop> <1263463781.3544.4714.camel@thor>
	 <1263526556.724.402.camel@pasglop>
Date: Fri, 15 Jan 2010 08:49:22 -0500
Message-ID: <a728f9f91001150549g40be6507y6fa0415229378759@mail.gmail.com>
Subject: Re: drm/radeon/kms: fix up LVDS handling on macs (v2)
From: Alex Deucher <alexdeucher@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/14 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Thu, 2010-01-14 at 11:09 +0100, Michel Dänzer wrote:
>> I have looked at radeonfb for a patch I posted a while ago to expose a
>> backlight class device with KMS, and I can only see what you describe
>> above affecting the LVDS_GEN_CNTL backlight level, not BLON or
>> BL_MOD_EN. Am I missing something?
>
> No, you aren't, it's radeonfb who is :-) I never quite got that part
> right. I was somewhat hoping several times that Hui and then Alex would
> manage to dig some info from ATI about what the right method is to drive
> those panels I think :-)
>

I've tried, but we are coming up on 10 years ago for some of these
chips so they aren't exactly fresh in people's minds and most of the
code is in long term storage at this point.  The problem is the
sequence is oem specific, even on the PC side there are cases were we
probably aren't doing it quite right.  The current non-mac code in kms
is the generic code that the PC bios team gave me.

Alex

> But my observation on those HW was definitely that when inverted,
> disabling the modulation was also turning the panel to full bright on,
> rather than turning it off.
>
>> Without my patch, KMS doesn't change the backlight level at all, so
>> assuming the firmware manages to enable the backlight, it should stay
>> like that.
>
> Your patch might make things better than they are today, I'm not arguing
> there :-) I'm just saying that now might be a good time to try to sort
> out exactly what should be done in there :-)
>
> Cheers,
> Ben.
>
>
