Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXJREKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXJREKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXJREKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:10:43 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:49973 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXJREKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GHgsJoMG0iMte3EvYzU6bQmZrnDYLEv/1hcQM+eIZHMvrnULXKkpYqlAGEOaYMkhLwmEVKUNQENr4ZcPjdiQrJ7Aks73R8Q6xL9KVLbycdlZEASRbYJhVRAbxAL71MpzeTcj5Werk3MLsXvmRQz9PesY9eldN/8iirApH1rlCPs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 06:10:12 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <471538C2.80806@m3y3r.de> <200710180536.18611.maximlevitsky@gmail.com> <4716D51E.2010509@garzik.org>
In-Reply-To: <4716D51E.2010509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710180610.13051.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 05:38:06 Jeff Garzik wrote:
> Maxim Levitsky wrote:
> > What sound codec do you have?
> > cat /proc/asound/Intel/codec*
> 
> Attached.
> 
> I'm on x86-64/Fedora 7 FWIW.
> 
> 
> > You probably have different issue, since your card is probed correctly
> 
> Agreed (though I was surprised that a correct probe did not yield a 
> single printk).
> 
> 	Jeff
> 
> 
> 


Thanks.

Probably everything is fine.

I added a new mixer control called "Master Volume"
it is a VolumeKnob.

It is a hardware control, that was unused in the driver before.

It affects the volume of all DACs
check if it is enabled, and set to maximum value.

This control affects the volume quite a lot, for example on my system
if I set it to middle, I almost hear no sound.

Maybe something else unrelated to my patches broke your sound too.


Regards,
	Maxim Levitsky
