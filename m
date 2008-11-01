Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKAW5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKAW5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 18:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYKAW50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 18:57:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:12541 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYKAW5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 18:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VI15TiKSNxwh6r1Lta/T4puMXWJU0yAX+LJ7xjx+wvA3aAgJOZ0HIzwiPcxZpHzew0
         Bps6KRHbr16uHL/SvHW92xy4dBiEUCxeZ0iSenK+BqoXPsYecn/eboLcv+LSEdSGmT3A
         F/DwRGrxkkrK388ShDBBlpGnbv4ZvUuzTJWF8=
Message-ID: <6de6b1650811011557j3469581wf01b264ed307e1e3@mail.gmail.com>
Date: Sat, 1 Nov 2008 20:57:25 -0200
From: "Rafael Almeida" <almeidaraf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Weird behaviour on iwl3945 module
In-Reply-To: <20081031053950.e2d22e55.almeidaraf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031053950.e2d22e55.almeidaraf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 5:39 AM, Rafael Cunha de Almeida
<almeidaraf@gmail.com> wrote:
> Hello,
>
> I'm using Debian lenny (linux 2.6.26) and I have a iwl3945 wireless
> card. My laptop is a lenovo r61i. I've notice that, when I turn off
> the wireles/bluetooth switch the wireless module isn't removed, the
> kernel even displays a few warnings:
>
> % dmesg | tail -n11
> [ 1219.735652] iwl3945: Radio Frequency Kill Switch is On:
> [ 1219.735652] Kill switch must be turned off for wireless networking to work.
> [ 1219.787767] usb 1-1: USB disconnect, address 2
> [ 1221.291865] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
> [ 1221.294246] iwl3945: MAC is in deep sleep!
> [ 1221.341983] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
> [ 1221.345953] iwl3945: MAC is in deep sleep!
> [ 1221.405968] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
> [ 1221.450835] iwl3945: MAC is in deep sleep!
> [ 1221.612230] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
> [ 1221.632612] ACPI: PCI interrupt for device 0000:03:00.0 disabled
>
> So, when I turn the switch back on, my wireless card is not
> operational. I have to manually remove and then reinstall the iwl3945
> module in order to the device to resume working. The bluetooth device
> doesn't have that issue.
>
> Is that an expected behaviour? Would it be impossible or undesirable
> to the kernel to behave differently? Is it already fixed in the newest
> kernel version (or on the -mm branch)? I am willing to hack into the
> kernel code in order to fix that problem, if someone would give me
> pointers of where to start.
>
> []'s
> Rafael
>

In order to give the issue some closure, I've recently had the chance
of running linux 2.6.28-rc2. The kill switch works fine on the new
version :-). I suggest anyone that's having problems with this
wireless card to upgrade their kernels, as things seems to have
changed recently.
