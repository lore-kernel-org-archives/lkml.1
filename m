Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbXHFQe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbXHFQe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXHFQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:34:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36554 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbXHFQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:34:18 -0400
Date: Mon, 6 Aug 2007 18:34:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708061832400.13469@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> 
 <1186317610.5220.3.camel@daplas>  <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
  <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
 <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1255711070-1186418057=:13469"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1255711070-1186418057=:13469
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 7 2007 00:06, Jeff Chua wrote:
>On 8/6/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>> >            ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
>> That looks pretty much like all-one-bits (ÿ = 255).
>> What about vcsa1 (use hexdump -C)?
>
># hexdump -C /dev/vcsa1
>00000000  19 50 00 18 ff ff ff ff  ff ff ff ff ff ff ff ff  |.P..............|
>00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
>*
>00000fa0  ff ff ff ff                                       |....|
>00000fa4
>
>Yep, it's all one's.

If no s2ram was involved at all, and vcs and vcsa output was as you
describe, then your display whould actually show white blinking ÿs on a
gray background. :>

>And once "s2ram" (without parameter) is executed, there's no way to
>restore back the console in text-mode even using "s2ram --force
>--acpi_sleep 1 --vbe_mode" until a "suspend-to-disk" or a reboot.
>
>"s2ram --force --acpi_sleep 1 --vbe_mode"  will only work on
>non-messed-up-console.


	Jan
-- 
---699020219-1255711070-1186418057=:13469--
