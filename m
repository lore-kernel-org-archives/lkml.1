Return-Path: <linux-kernel-owner+w=401wt.eu-S1765988AbXJRDg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765988AbXJRDg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761009AbXJRDgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:36:48 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:31946 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869AbXJRDgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xuc2PYVGheSO2KT300064x/o/ez9Bx1QxtP+pDAnI2wHCK6Hf8Blx4geII8DYVm7GH94NTX2i/Dx56vhjXnpTr83i9/pbPsBcGqdQjGo6Dx05DZp4yxHxEa+82g1/8Av2E6UmBuYheGP/OCCk/S/tOlMwiFoikZ94wim3v8hBZ8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 05:36:18 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <471538C2.80806@m3y3r.de> <4716C68C.4030504@garzik.org>
In-Reply-To: <4716C68C.4030504@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710180536.18611.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 04:35:56 Jeff Garzik wrote:
> Thomas Meyer wrote:
> > $ dmesg
> > 
> > [schnipp]
> > 
> > ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
> > PCI: Enabling bus mastering for device 0000:00:1b.0
> > PCI: Setting latency timer of device 0000:00:1b.0 to 64
> > hda_codec: STAC922x, Apple subsys_id=106b0200
> > ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> > HDA Intel: probe of 0000:00:1b.0 failed with error -16
> > 
> > [schnipp]
> 
> My sound ability similarly disappeared an upstream kernel <24 hours old 
> (includes the ALSA merge).
> 
> [jgarzik@core ~]$ lsmod | grep -i snd
> snd_hda_intel         367396  2
> snd_pcm_oss            42080  0
> snd_mixer_oss          16640  2 snd_pcm_oss
> snd_pcm                79624  2 snd_hda_intel,snd_pcm_oss
> snd_page_alloc          9040  2 snd_hda_intel,snd_pcm
> 
> [jgarzik@core ~]$ lspci | grep -i audio
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
> Definition Audio Controller (rev 01)
> 
> [jgarzik@core ~]$ dmesg | egrep -i 'snd|hda'
> [jgarzik@core ~]$
> 
> mplayer says
> 
> 	AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
> 
> but no sound is emitted.
> 
> Earlier kernels been working fine since hda_intel was introduced.
> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

What sound codec do you have?
cat /proc/asound/Intel/codec*

You probably have different issue, since your card is probed correctly


Regards,
	Maxim Levitsky
