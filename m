Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZFDJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZFDJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFDJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:14:28 -0400
Received: from comar.uludag.org.tr ([193.140.100.220]:57365 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbZFDJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:14:28 -0400
Message-ID: <4A2790F7.1070303@pardus.org.tr>
Date: Thu, 04 Jun 2009 12:16:39 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [BUG] Loading parport_pc kills the keyboard if ACPI is enabled
References: <4A278FEC.3000805@pardus.org.tr>
In-Reply-To: <4A278FEC.3000805@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan wrote On 04-06-2009 12:12:
> Hi,
>
> I was having this issue since 2.6.30_rc1 (if I remember correctly) but I
> didn't have time to analyze and report here until today.
>
> If I don't give acpi=off during boot, the keyboard becomes unusable when
> udev starts. The connection type of the keyboard don't matter at all, I
> tried with a USB and a PS/2 one.
>   

Note that the fact that the keyboard working when acpi=off seems to be
that udev don't probe parport* stuff in that case. I inserted parport by
hand and the keyboard is gone again as well:

[   30.696938] parport_pc 00:0d: reported by Plug and Play BIOS
[   30.697000] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   30.780388] lp0: using parport0 (interrupt-driven).
[   30.804130] ppdev: user-space parallel port driver
