Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZJ2Rko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZJ2Rko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbZJ2Rkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:40:43 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44178 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbZJ2Rkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e18kbsEmTrKM2+oFYLyvQTJyM1USbx1Awa1MCEoE33u4Qa2PHEV4jwKYlBQEaj8Ku+
         Hm3eFQRo7tbsZbkkWrS4sJ4Lf+Bkju8fE2dG0K5Q2iY9i0tmiCR73bUOzKcDmrnVOIY4
         4ZGwBEgCacZwku4yL8v6uHb3Zx935FDvogXn0=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	 <20091005092148.4341d9ab@jbarnes-g45>
	 <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	 <20091029094723.7e5a3376@jbarnes-g45>
	 <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
Date: Thu, 29 Oct 2009 13:40:44 -0400
X-Google-Sender-Auth: 70565d02822841be
Message-ID: <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 1:22 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 12:47 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Wed, 7 Oct 2009 23:44:35 -0400
>> Andrew Lutomirski <luto@mit.edu> wrote:
>>> > I probably need to save/restore some more of the power saving state
>>> > across suspend/resume...  Can you file a bug for this at
>>> > bugs.freedesktop.org so it doesn't get lost?
>>>
>>> Submitted as https://bugs.freedesktop.org/show_bug.cgi?id=24386
>>
>> Andrew, are you still seeing this after the various fixes that have
>> landed in Linus's tree?
>
> I'm not entirely convinced it's suspend/resume related any more, but
> there's still a problem.  When I got your email, my system had been up
> for awhile (running Linus' 964fe080d94db82a3268443e9b9ece4c60246414
> (approximately 2.6.32-rc5) plus drm-intel/for-linus from a couple days
> ago for the watermark fix)), suspended and resumed several times, and
> logged in and out several times.  I turned off wireless and power
> consumption was 9.0 watts.
>
> I switched to console and killed X.  Power consumption still 9.0
> watts.  The system was almost completely idle.
>
> I rebound i915.  Power consumption dropped to 7.3 watts.
>
> I restarted X and logged back in.  System froze hard (whoops).
>
> It looks like something is getting the chip stuck in a high-power state.

I just suspended and resumed and power consumption stayed low.  I'll
try and get an intel_reg_dumper diff next time I trigger this bug.

--Andy
