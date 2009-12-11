Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZLKKqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZLKKqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbZLKKqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:46:08 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58199 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbZLKKqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:46:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qp7RGTgmt/zEl7FVWJ0vkJ7cev0n/Cacr0bNXsVuqNvHHgMohb9/BlVljHtsa7Q/kL
         0koSaDNkKtywzAAA8JD0/R3fZfS+TiETBkaKsdjNgtNtSj2l1aAJADBpIppFk8dofQAs
         uY6eDGQwvbp8U0uOPtsKJLwDUOvf2+DCUrKdQ=
MIME-Version: 1.0
In-Reply-To: <4B221EDA.5020902@garzik.org>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	 <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
	 <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
	 <20091211091843.0a543136@lxorguk.ukuu.org.uk>
	 <4B221EDA.5020902@garzik.org>
Date: Fri, 11 Dec 2009 20:46:12 +1000
Message-ID: <21d7e9970912110246i7fec470el74dc15e24c2f603@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 8:28 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 12/11/2009 04:18 AM, Alan Cox wrote:
>>
>> F11 certainly shipped some bits of it for 2D support. I am not sure if
>> F10 shipped a purely userspace set up. Neither had it enabled as the
>> default driver - they used "nv" or "vesa" depending upon the card.
>
> F11 uses nouveau here.  It is actually a pain to get 'nv' going as an
> alternate -- bugs have been filed.  Makes kernel dev more difficult for me.
>  I was actually told, by Fedora people, that I should be hacking on the
> Fedora (rpm-based) kernel, rather than a 100% upstream kernel like I have
> been hacking/booting for the past decade, as a result of this setup (needing
> nouveau kernel support, thus needing Fedora rather than upstream kernel).

It wouldn't have helped the ABI was broken between F11 and now, so you'd be
in the same boat putting this code upstream via staging in no way
means you can run
it with the F11 userspace or ongoing even with the F12 one.

Dave.

>
>        Jeff
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
