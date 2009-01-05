Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZAETUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZAETUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZAETUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:20:38 -0500
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:37500 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751492AbZAETUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:20:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rQThs+WHwVB19/xK43ER9ckuFjU+rySVgH7WGBpDLe5TesgfpgdpUYy/WOjddXcmXXjLSMOvW029rb0DhsCQTPvXHUv5oRqYEg+n6GcBKlxClDxubgCJWgzCwJcFrfeB;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.28 1/3] PCI-quirks: Unhide MCH5/6 memory controller configuration device
Date: Mon, 5 Jan 2009 11:20:35 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
References: <20081223215030.GA32525@rere.qmqm.pl> <20090101190254.GA22845@rere.qmqm.pl>
In-Reply-To: <20090101190254.GA22845@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901051120.35726.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 1, 2009 11:02 am Micha³ Miros³aw wrote:
> Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
> The same happens for i82865P/PE. Add a quirk to enable this device.
> This allows i82875 EDAC driver to bind to chipset's dev #6 and not
> dev #0 as the latter is used by AGP driver.
>
> This is rebased against 2.6.28 vanilla kernel, including trimming
> of long lines.
>
> After testing this patch for couple of days on my laptop (i82856P)
> it looks like something is resetting device 0 (MCH) config register
> 0xF4 to zero and effectively disabling the device again. The delay
> looks random to me. I can easily update the register using
> 'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
> correct values in lspci output afterwards. This is probably
> BIOS's fault. This changes nothing as far as i82875P EDAC driver
> is concerned as it has the same assumption that BIOS is well behaved.
>
> In case some really broken BIOS is found, this can be wrapped around
> some new Kconfig #ifdef.
>
> Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

This one doesn't apply for me, can you resend a new one against my linux-next 
branch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

