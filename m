Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZCMKam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZCMKam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZCMKad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:30:33 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:55221 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZCMKac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:30:32 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 06:30:32 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DxbcyBSWQYuxYxvdmaMUZYyUxeeSG8ZnNeeVTq4LKm5jUstpGYtlv6oR2JRCcyTBJt
         XFCBFNi6VcED/UteNwSvhGjYKHe6C7fv4XroTq5LJyvfYDtdeYX/LiBk/AN+lgLbsd5E
         Lx6CDlYNaCu1PDQR7Yl//xhECApTFUXWu1Spo=
MIME-Version: 1.0
In-Reply-To: <s5h1vt1vnio.wl%tiwai@suse.de>
References: <49B9959F.1080705@digadd.de> <49BA0EDA.4080606@ladisch.de>
	 <s5h1vt1vnio.wl%tiwai@suse.de>
Date: Fri, 13 Mar 2009 11:24:16 +0100
Message-ID: <fd3eb9bf0903130324o59d5c4a0k47e584bdf2448a02@mail.gmail.com>
Subject: Re: [alsa-devel] How can PCI resource allocation fail?
From: =?UTF-8?Q?Vedran_Mileti=C4=87?= <rivanvx@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       "Christian P. Schmidt" <schmidt@digadd.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 9:24 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 13 Mar 2009 08:44:26 +0100,
> Clemens Ladisch wrote:
>>
>> Christian P. Schmidt wrote:
>> > I'm toying with the alsa-driver for the Creative Labs X-Fi. I'm working
>> > on the PCI Express version of this card,
>>
>> ... which isn't supported ...
>
> You can try sound-unstable tree.  If your device is a Vista-compatible
> model, it may work with snd-hda-intel (with a luck).
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-unstable-2.6.git
>
> The corresponding alsa-driver snapshot is:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/tiwai/snapshot/alsa-driver-unstable-snapshot.tar.gz
>
> If it's no Vista-compatible (i.e. HD-audio compatible) model, you can
> try topic/sbxfi branch of the sound unstable tree above.  Just
> pull/merge the branch after cloning.
>
>
> Takashi
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>

IIRC, all PCI-E X-Fi cards are UAA (this part I'm pretty certain
about), and all UAA X-Fi cards are PCI-E (I saw at some point some OEM
X-Fi card that had two chips, one on the front and other on the rear,
so not totally sure about this one).

Vedran
