Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZJGKKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZJGKKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZJGKKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:10:22 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:51668 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZJGKKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qqzelVIhSKEz41hfNLwFDPkFinMou+Aoa4Xebv9Gu9oA1MwgmEgj4jIBQAfHILB3Ng
         utfNHcPFnR5u3NmqrFpNf5j0JbmBOe4N9F3T/cQQ5xrxotIwUszX08lNQ+hj0v+s1nGI
         +HL2q/Mx5Nnt59r1Lddq632namk9xELqlETIg=
MIME-Version: 1.0
In-Reply-To: <s5hvdiry7f1.wl%tiwai@suse.de>
References: <9b06e8d20910040639v3a91a5c3n8b87aced5de82abd@mail.gmail.com>
	 <s5hvdiry7f1.wl%tiwai@suse.de>
Date: Wed, 7 Oct 2009 12:09:43 +0200
Message-ID: <9b06e8d20910070309k56f0d019g826c8946d232545a@mail.gmail.com>
Subject: Re: SB600 sound module disabled on kexec
From: =?ISO-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/7 Takashi Iwai <tiwai@suse.de>:
> At Sun, 4 Oct 2009 15:39:41 +0200,
> Loïc Grenié wrote:
>>
>>     Hi,
>>
>>     I have had this problem for a long time and not reported
>>   it earlier. Sorry. This might have been true already for
>>   2.6.18...
>>
>>     I have a laptop with an ATI (AMD) SB600 south bridge
>>   including a sound module. When I boot the kernel from the
>>   bootloader, there is no problem: hda-intel drives the module.
>>   When I kexec the kernel, there is a problem with IRQ
>>   configuration and the sound is disabled.
>
> Could you check whether enable_msi=1 option for snd-hda-intel has
> any influence?  I enabled this as default for 2.6.33, and I'd like to
> know any good/bad influence by that.

    No, it does not: on bootloader-boot snd-hda-intel  loads correctly and
  sound is enabled, on kexec however sound is disabled with the same
  "cannot grab IRQ 0" message.

     Thanks,

       Loïc
