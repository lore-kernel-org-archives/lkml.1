Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYL3RJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYL3RJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYL3RIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:08:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYL3RIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:08:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=fXQMCTpHwVjLZ5RTtiC2woRJx7QOHhBtned5Fl9EPVAlTsI1LdGLDOK2DcwzswP1l
	ReiIfccbGk7JHWxV2YPlw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0812300605250.11356@p34.internal.lan>
References: <alpine.DEB.1.10.0812300605250.11356@p34.internal.lan>
Date: Tue, 30 Dec 2008 09:08:46 -0800
Message-ID: <da824cf30812300908x3ff6061cn569203d5163664ea@mail.gmail.com>
Subject: Re: 2.6.28: Is there a way to disable sata probing for certain ports?
From: Grant Grundler <grundler@google.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.69
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 4:24 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> When I boot from an Intel X25-E SSD, it takes roughly a few seconds;
> however, items such as:
>
> $ dmesg|grep link\ down
> [    2.447030] ata4: SATA link down (SStatus 0 SControl 300)
> [    4.481288] ata5: SATA link down (SStatus 0 SControl 0)
> [    6.501288] ata6: SATA link down (SStatus 0 SControl 0)
> [    8.522038] ata7: SATA link down (SStatus 0 SControl 0)
> [   10.552288] ata8: SATA link down (SStatus 0 SControl 0)
>
> Scanning for devices on channels that have nothing connected adds to the
> boot time, is there anyway to turn off/disable scanning for certain ports to
> help speed the boot process?

Some BIOSs allow one to enable/disable each port individually.
Have you checked the BIOS config menus for such an option?

drivers/ata/libata-core.c declares "ata_force_param_buf" but I don't
see any documentation for it despite the reference to
Documentation/kernel-parameters.txt .

hth,
grant
