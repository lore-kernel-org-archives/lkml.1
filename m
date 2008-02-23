Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbYBWSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbYBWSqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYBWSqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:46:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:2371 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbYBWSqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:46:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jMLpwvFT5aMb/5oXFRpArYOKrUeqEqPm5qug4vJZ4fU5pio3TdvZbqsf0JdQpABTbdHEJSkK7UZf/XnJwcBUBqOCcnoUts6RS+JTFv9x3YQftMwuawKKWbcfoCt0UhM9x5f6JV92/wxGAowZJtZ918WV6KHJRHcZzgCYTUtXJNA=
Message-ID: <19f34abd0802231046m2e8d3bcav224ae91f8e975579@mail.gmail.com>
Date: Sat, 23 Feb 2008 19:46:35 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Cc: "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080223183138.59d18e26@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
	 <20080223183138.59d18e26@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 7:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> O> I don't see the connection between (no-)smp and ata. Something with
>
> > interrupt routing/IPI, missing irq ack? Booting another !SMP kernel
>  > works fine. The problem also exists in 2.6.24-rc2.
>
>  Almost certainly interrupt routing try smp but with noapic and see if it
>  fails as well ?

Just a quick follow-up. On regular bootups, I get this message:

ata1: SATA max UDMA/133 cmd 0xf8850100 ctl 0x00000000 bmdma 0x00000000 irq 218
ata2: SATA max UDMA/133 cmd 0xf8850180 ctl 0x00000000 bmdma 0x00000000 irq 218

while the nosmp one gets this (the screenshot cut the irq part):

ata1: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304100 irq 223
ata2: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304100 irq 223

Don't know if the irq # change is significant or not. Will try noapic now.


Vegard
