Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZKJHsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZKJHsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZKJHsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:48:15 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:47867 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZKJHsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UAtq153AZ7FXvOK1eX0qhmFFCVmnV3+PzClU1iFeNeT0DJBxTdL+xM78cnnBGEM1e3
         BWjFmbdRqJXdgepRjIIpcd62DpwFZlFrZUxaK9V10b2YJ/N80Ig7rWkXDuqvHVBzQ6kn
         istLlTM6XPDlJi8VkdOLdUPVpkB+ML25K/9h4=
MIME-Version: 1.0
In-Reply-To: <3642a3130911092304x5c8fe8ddme1df39e6981cfe0a@mail.gmail.com>
References: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
	 <20091109175728.4eec67b9@lxorguk.ukuu.org.uk>
	 <3642a3130911092236p11ef0502se12788800c8d2084@mail.gmail.com>
	 <3642a3130911092304x5c8fe8ddme1df39e6981cfe0a@mail.gmail.com>
Date: Tue, 10 Nov 2009 08:48:19 +0100
Message-ID: <b637ec0b0911092348x29453bco7f7ca94f3772601@mail.gmail.com>
Subject: Re: Kernel 2.6.29+ broke Cisco VPN Client
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Mariusz Smykula <mariuszs@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please have a look at:

http://forum.tuxx-home.at/viewtopic.php?f=15&t=790#p5227

There is a patch there that can be used to make CiscoVPN work with the
latest stable kernels. For me it worked fine (over a wifi connection)
until I lost interest as now I'm able to use vpnc, thanks to the
people on the vpnc support forum.

Hope this helps.

[BTW, CiscoPVN is OT on this list]

On Tue, Nov 10, 2009 at 8:04 AM, Mariusz Smykula <mariuszs@gmail.com> wrote:
> On Mon, Nov 9, 2009 at 6:57 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I must have imagined openconnect. Failing that you need to talk to your
>> distro if they shipped the module or to cisco.
>
> OpenConnect supports the new Cisco "AnyConnect" SSL VPN, not the old
> IPsec-based VPN. Cisco ended support for this software and devices and
> is not interested in helping us. All we have is open sourced cisco vpn
> client which is broken since 2.6.29.
>
> --
> Mariusz Smykuła
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
