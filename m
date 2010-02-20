Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0BTWu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 17:50:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:59377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753503Ab0BTWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 17:50:27 -0500
X-Authenticated: #2387525
X-Provags-ID: V01U2FsdGVkX1+CbzJghBmCN/73jJv2fzj3Jux0Vi2HIHsOqVVsBu
	mpqLVA69QCzK+a
Message-ID: <4B806730.5040301@gmx.de>
Date: Sat, 20 Feb 2010 23:50:24 +0100
From: Axel Uhl <axel.uhl@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
References: <4B72941A.7060704@gmx.de>	<4B74BDCF.1010805@kernel.org>	<4B74F263.1060709@gmx.de>	<4B7505CA.60409@kernel.org>	<4B75154B.8030507@gmx.de>	<4B7B548B.4040606@kernel.org>	<4B7C5696.7030609@gmx.de>	<19325.7006.892019.748974@pilspetsen.it.uu.se>	<4B7EDE2F.8030107@gmx.de>	<19326.64703.561400.379749@pilspetsen.it.uu.se>	<4B7FA14B.2090809@gmx.de> <19327.53577.55472.205452@pilspetsen.it.uu.se>
In-Reply-To: <19327.53577.55472.205452@pilspetsen.it.uu.se>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms060201020803060804040803"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060201020803060804040803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I now disabled CONFIG_IDE. pata_via now takes over the IDE disks. 
Changes in /etc/fstab were necessary because /dev/hd[abcd] now became 
/dev/sd[cdef]. Everything else seems to work normally for now. I'll 
check if this also makes the exception go away altogether.

Thanks again and best regards,
-- Axel

Mikael Pettersson wrote:
> (Please don't top-post on Linux mailing lists.)
> 
> Axel Uhl writes:
>  > Hi Mikael,
>  > 
>  > BTW, how do you know that all my PATA controllers are driven by libata? 
> 
> Because you wrote:
> 
>  > >  > I also enabled 
>  > >  >   pata_via but was unsure which IDE driver to disable.
> 
> and pata_via is libata's replacement for IDE's via82cxx.
> 
> Since you kept both drivers enabled, it seems that IDE's via82cxx won the
> race to claim the hardware. Bummer.
> 
> Just disable CONFIG_IDE.
> 

-- 
Find Security Certificate at http://www.axel-uhl.de/cgi-bin/cacert.cgi

--------------ms060201020803060804040803
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
MTQYBF9leVmbJsx2AAAAAAAA
--------------ms060201020803060804040803--
