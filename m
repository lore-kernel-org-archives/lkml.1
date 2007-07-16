Return-Path: <linux-kernel-owner+w=401wt.eu-S1764182AbXGPOth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764182AbXGPOth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbXGPOta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:49:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:9757 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbXGPOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dGRhE2FMQ8tesXkN5RN13zZL6am3N906wGqeTu+83H+4Y6QADcFuYDwrGatRxWQhUT1eNyBPjBB4DObmlbNHt8ZO3/ye7hSSLq5dgso1JxpwcDtBrkaRh0NVbQYMvfmylhlnxGZzIR4GGGgt/1c7fAoFgufIkcX9AkdHIzwCu8I=
Message-ID: <d120d5000707160749r1084ab4ex8d2c4e89e6134d41@mail.gmail.com>
Date: Mon, 16 Jul 2007 10:49:28 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707132304.30795.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707132249.26106.christophpfister@gmail.com>
	 <200707132304.30795.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 7/13/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> Am Freitag, 13. Juli 2007 22:49 schrieb Christoph Pfister:
> > Hi,
> >
> > After a kernel update I recognised that my keyboard sometimes didn't work
> > after booting up. I found out that the issue appeared quite reliably after
> > a cold reboot and not pressing any key (for example not selecting stuff at
> > the bootloader) till the machine fully booted up.
> > Because git head (4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4) didn't solve
> > the problem I did a bisect and your commit was found to be the culprit (the
> > second last build succeeded 5 of 5 times during my tests and the last build
> > failed 2 of 3 times).
> >
> > Can anybody please shade light on this?
> >
> > Thanks,
> >
> > Christoph
>
> Forgot to mention dmesg: "input: AT Translated Set 2 keyboard
> as /class/input/input0" is shown in both (working / failing) cases (no
> additional / related lines nearby).
>

Could you please boot with "i8042.debug log_buf_len=131072" and send
me full dmesg?

Thanks!

-- 
Dmitry
