Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbYFGSHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbYFGSHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761146AbYFGSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:07:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3697 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYFGSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q1PB+Y0jyFIzIO1HDMTLxbWgojASqr93nLbGn9zVIvxwsnEXeQOW9IZ8+Tc6jtL26q
         JJS9yJFcoJyM4F4ON+hyDgMpSAMwHIAadlR/TEPvgnAPOSWknZ8gTRpY85kj+TWPDMOS
         WMfnhbkbwtRuSDlODsaHwmgrD6i7FstDRr/1k=
Message-ID: <d120d5000806071107v4ce5fde8gbda57a4024e01a0b@mail.gmail.com>
Date: Sat, 7 Jun 2008 14:07:00 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Stas Sergeev" <stsp@aknet.ru>, "Dmitry Torokhov" <dtor-oss@comcast.net>,
       "Takashi Iwai" <tiwai@suse.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [patch][resend] pcspkr: undepend of snd-pcsp
In-Reply-To: <484ACB89.7040606@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484ACB89.7040606@aknet.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,



This is wierd, I have all 3 your mails :) The patch is in the
'for-linus' branch of my tree and should be in mainline next time I
ask Linus to pull.

Dmitry


On 6/7/08, Stas Sergeev <stsp@aknet.ru> wrote:
> Once again this mail returns to me
> as a spam, without reaching Dmitry :(
>
> Hello.
>
> It should be possible to build
> pcspkr driver together with snd-pcsp.
> Even though right now there is no
> good plan to get these drivers to
> work together, some things were done,
> namely:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16dc42e018c2868211b4928f20a957c0c216126c
> and
> https://bugzilla.redhat.com/show_bug.cgi?id=448425
> which looks more or less sufficient.
>
> And there was a discussion already:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/4/29/1652654
>
> The attached patch allows pcspkr to
> be built together with snd-pcsp.
>
> Dmitry, could you please apply?
>
>
> ------
> Allow pcspkr to be built together with snd-pcsp.
> The bug in a driver core that prevented this in
> the past, is now fixed by
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16dc42e018c2868211b4928f20a957c0c216126c
>
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> CC: Takashi Iwai <tiwai@suse.de>
>
>


-- 
Dmitry
