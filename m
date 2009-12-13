Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZLMX2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZLMX2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLMX2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:28:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38558 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZLMX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=qZsQwLmpdPknm95Ft/46p7WTcVfKrIn5fy3SuMwjudRbH5+bplWRBLgXtekRlJdhl5
         oU8f1X6EL+Ss8MyC2TTRCBbQDcHWHHW9ktk14CeHHoAqKLgkthX9OMyQ+G0vuhlrrNqs
         UG1Oiyz41PJIAMJz2jA54h4Og8Y8GeCkRo7gU=
MIME-Version: 1.0
In-Reply-To: <4B22DD11.7000905@gmail.com>
References: <ffd8902a0912110121k795223ar6af644c41cd357b8@mail.gmail.com> 
	<4B22DD11.7000905@gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sun, 13 Dec 2009 15:27:48 -0800
X-Google-Sender-Auth: a32491360c6451ed
Message-ID: <2c0942db0912131527x118f9689oe1dc128543f4fc27@mail.gmail.com>
Subject: Re: Q: Why I do have to restart alsa everytime after a resume from 
	disk/ram ? Is this alsa- or kernel or config related??
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Christian Hartmann <cornogle@googlemail.com>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 4:00 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 12/11/2009 03:21 AM, Christian Hartmann wrote:
>>
>> hello list,
>>
>> everytime I suspended to disk or to ram, regardless of the used kernel
>> (git or stable from distri), I must restart alsa to hear sound again.
>> searched google and tried a lot but still the same awful behaviour.
>> Has anybode some suggestions for me? is this alsa related ? or is this
>> a kernel issue which could be dealt here?
>
> I'm not sure what you mean by restarting ALSA, do you mean reloading the
> audio device module or something?
>
> You didn't mention which kind of sound hardware you were using either..

Data point: Older versions of PulseAudio are very picky about the
timing data that comes back from ALSA, and throws a hissy-fit and goes
and sulks if it believes it's getting lied to. Perhaps you need to try
upgrading the PulseAudio packages, and try again.
