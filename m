Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYIZNMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYIZNMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYIZNMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:12:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYIZNMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jirT0DBBt6dt7E6qSAlbARv3gKngVJNO23t0gk0eYm03eYyVobyLj3JvT6eaFiYy10
         cc5kLdymhT2O8qVKj3yEmbyJlSm9heKm7Ks9i9bg5quCZwbb5tQNQfPOYpMUQbTUPCQP
         yqFHNHEQj/SJd0dY5gkz/AmWVJF1ySIqMRNBk=
Message-ID: <6101e8c40809260612o3ff3d814x3727e0f7ec2f7e27@mail.gmail.com>
Date: Fri, 26 Sep 2008 15:12:18 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: wilhelm-siegfried.knatschke-koenigsberg@chezmoi.com
Subject: Re: 2.6.26.x hangs on amd64/smp
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200809260859.m8Q8xp0r008656@rayleigh.systella.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809260859.m8Q8xp0r008656@rayleigh.systella.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have similar problem, but the hw is asus p5q-e, c2q q9300, 4gb ram + rhd3450.

The X started very slowly ~1-2min, and randomly crashed the system,
with Freebsd all ok, but with linux not.
The other problem is, when I cp-ed 4gb<= file, this caused to file
corruption, when I booted with mem=512M kernel parameter, then this
file corrouption get off. I have memtest some hour long run, and with
freebsd i have ~1< uptime, then i turned off the pc. ...

On 9/26/08, BERTRAND Joel <bertrand@rayleigh.systella.fr> wrote:
> From: BERTRAND Joel <joel.bertrand@systella.fr>
> Newsgroups: linux.kernel
> Subject: 2.6.26.x hangs on amd64/smp
> Reply-To: mt1@systella.fr
>
> 	Some news.
>
> 	I have done some tests with the _same_ configuration, but without
> 	resident X (and console on a serial line). I'm not able to reproduce
> 	this bug anymore even with a load average
> 	greater than 30 (memory usage : 4GB + 6GB swap). Thus, this trouble
> 	seems to be X related.
>
> 	Graphic card is :
> 01:00.0 VGA compatible controller: ATI Technologies Inc M76 [Radeon
> Mobility HD 2600 Series]
>
> 	Xorg configuration :
> Section "Device"
>     Identifier  "ATI Technologies Inc ATI Default Card"
> 	Driver      "radeonhd"
> #   Driver      "fglrx"
> 	BusID       "PCI:1:0:0"
> EndSection
>
> cauchy:[~] > dpkg-query -l | grep xorg
> ii  xorg                                                    1:7.3+16
> ...
> ii  xserver-xorg-video-radeonhd                             1.2.1-2
>
>
> 	I'm writing a bug report on Xorg website.
>
> 	Regards,
>
> 	JKB
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
