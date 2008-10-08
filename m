Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYJHMEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYJHMEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYJHMEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:04:32 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:50937 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbYJHMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:04:31 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Toggling GPIO at 38Khz
To: Jon Smirl <jonsmirl@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 08 Oct 2008 14:15:19 +0200
References: <bkydL-21G-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KnXwl-0006JX-EF@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl <jonsmirl@gmail.com> wrote:

> I'm working on getring the LIRC IR subsystem integrated into the
> kernel. One common IR hardware implementation is based on standard
> serial ports. It uses the serial port's DCD and DTR as GPIO pins.
> This common IR hardware does not have a transmit modulator and is
> modulating the IR signal in software. Luckily is has hardware
> demodulation.
> 
> There are four common IR frequencies - 36Khz, 38Khz, 40Khz, 56Khz. I
> need to create these frequencies in software. Data is then transmitted
> as 400-600us burst of these frequencies. Around 10-30 clock pulses.
[...]

The ALSA PC-Speaker sound driver might do something similar ...

