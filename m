Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752283AbYLRF25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbYLRF25 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 00:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYLRF2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 00:28:47 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39359 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYLRF2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 00:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=br6N3WUQQ/gt0w14jvgN/3kMP0waM/Wd4QKRX1GA0xyLVCXvE98QK6EXg0ny8rfnpz
         +6rEsaTyBZeMiwMxVlj3+fpqvC5/jYp4OV42tBeygx2oATCXrmorT2k85c2TktLEbrM/
         0zg/+SmUOmKb08LkW8jQ3aVmfW/KML/yNrXy4=
Message-ID: <aa79d98a0812172128h55fca781w937744002e5b2fd7@mail.gmail.com>
Date: Thu, 18 Dec 2008 08:28:45 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: add handle_irq() to allow interrupt injection
Cc: "Ingo Molnar" <mingo@elte.hu>, "the arch/x86 maintainers" <x86@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <494985E1.90304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494810F0.1010101@goop.org> <20081216204946.GE14787@elte.hu>
	 <494985E1.90304@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 2:06 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
...
> +#ifdef CONFIG_X86_64
> +asmlinkage
> +#endif
> +unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
> +{
...
iirc asmlinkage is "none" on x86-64 so you could safely save it here without
CONFIG. i hope I didn't miss anything :)
