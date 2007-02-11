Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXBKNE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXBKNE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbXBKNE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:04:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:40565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbXBKNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ja8i/SU/ws4C1/nrzFcdVcafBlQkoeZo92tNOqPlAxZVcCBmlN7ppxDHInPEkopLnX8eA2UhBdIymD9TzIVYgkp0RBUOWQ9nca30z/i2XoSveieGn+RkIQMwKjL7rbuKuuMYqnv4s3tjJGBF8xOVuorb+SUo2+jLIRTu4+roKeE=
Message-ID: <40f323d00702110504i3a7b1421p9309eac1cfd75553@mail.gmail.com>
Date: Sun, 11 Feb 2007 14:04:23 +0100
From: "Benoit Boissinot" <bboissin@gmail.com>
To: rol@witbe.net
Subject: Re: 2.6.20/2.6.20-rc7 : ethX renumbered
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, rol@as2917.net
In-Reply-To: <011001c74dcf$c60c1c80$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <011001c74dcf$c60c1c80$2101a8c0@donald>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Paul Rolland <rol@witbe.net> wrote:
> Hello,
>
> I'm facing something quite strange... When booting one of these kernels
> (it's a new machine, I've not been running older kernels), the boot message
> says :
>
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> sky2 v1.10 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
> sky2 eth0: addr 00:18:f3:e0:5d:d4
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> sky2 v1.10 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
> sky2 eth1: addr 00:18:f3:e0:36:fd
>
> So, I'm expecting two interfaces : eth0 and eth1
>
> Unfortunately, at the end of the boot process, I can find eth1 and eth2,
> something/somewhat/someone has renumbered them ;

usually distro enable persistent interface naming with udev, check
/etc/iftab and see if you have something like
/etc/udev/something-iftab.rules

regards,

Benoit
