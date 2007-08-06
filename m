Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbXHFQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbXHFQqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXHFQqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:46:17 -0400
Received: from neon.samage.net ([85.17.153.66]:37613 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbXHFQqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:46:17 -0400
Message-ID: <39839.81.207.0.53.1186418772.squirrel@secure.samage.net>
In-Reply-To: <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
    <1186317610.5220.3.camel@daplas>
    <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
    <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
    <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
Date: Mon, 6 Aug 2007 18:46:12 +0200 (CEST)
Subject: Re: Linux 2.6.23-rc2
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "lkml" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 6, 2007 18:06, Jeff Chua wrote:
> On 8/6/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>> >            ���������������������������
>> That looks pretty much like all-one-bits (� = 255).
>> What about vcsa1 (use hexdump -C)?
>
> # hexdump -C /dev/vcsa1
> 00000000  19 50 00 18 ff ff ff ff  ff ff ff ff ff ff ff ff  |.P..............|
> 00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
> *
> 00000fa0  ff ff ff ff                                       |....|
> 00000fa4
>
> Yep, it's all one's.
>
> And once "s2ram" (without parameter) is executed, there's no way to
> restore back the console in text-mode even using "s2ram --force
> --acpi_sleep 1 --vbe_mode" until a "suspend-to-disk" or a reboot.

Does executing unicode_start, unicode_stop fixes it?

Greetings,

Indan


