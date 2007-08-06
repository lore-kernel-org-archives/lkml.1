Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXHFQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXHFQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXHFQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:06:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:18607 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbXHFQGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ncb+/rZzfEs3g9K3vb1kn6QEfzGUynWkwCKzVUhmk2rNBJbEr0zI6GAd21LHF2hvOnWjd4r9TxQPuDTsbwwvXolHsMr32PlZpMZp2HM8V2CX/uRK/76XaSjQwh/VsK6EjRZ76H/hclXF03xPW7jt1C9yI7wfsTscWGwbJ1j7iUQ=
Message-ID: <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
Date: Tue, 7 Aug 2007 00:06:46 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Linux 2.6.23-rc2
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
	 <1186317610.5220.3.camel@daplas>
	 <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
	 <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:

> >            ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
> That looks pretty much like all-one-bits (ÿ = 255).
> What about vcsa1 (use hexdump -C)?

# hexdump -C /dev/vcsa1
00000000  19 50 00 18 ff ff ff ff  ff ff ff ff ff ff ff ff  |.P..............|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00000fa0  ff ff ff ff                                       |....|
00000fa4

Yep, it's all one's.

And once "s2ram" (without parameter) is executed, there's no way to
restore back the console in text-mode even using "s2ram --force
--acpi_sleep 1 --vbe_mode" until a "suspend-to-disk" or a reboot.

"s2ram --force --acpi_sleep 1 --vbe_mode"  will only work on
non-messed-up-console.


Thanks,
Jeff.
