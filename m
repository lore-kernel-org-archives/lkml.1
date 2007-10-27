Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbXJ0Ldh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbXJ0Ldh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXJ0Ld2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:33:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXJ0Ld1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:33:27 -0400
Date: Sat, 27 Oct 2007 13:33:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
In-Reply-To: <fft89p$rko$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0710271333150.30465@fbirervta.pbzchgretzou.qr>
References: <fft89p$rko$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26 2007 19:31, Markus Elfring wrote:
>
>Two ways are mentioned in the Makefile for the Linux kernel 2.6.31.1 to specify output
>diretories. The description of the environment variable "KBUILD_OUTPUT" is missing from
>the file "README".
>
>I am trying to generate all executable files for the current stable kernel release on my
>openSUSE 10.3 system.
>
>Sonne:/usr/src/linux # make mrproper
>Sonne:/usr/src/linux # cp -p /boot/config-2.6.23.1-0-adjusted .config
>[reactivate backup copy]

.config should be copied to the output directory.

>Sonne:/usr/src/linux # export KBUILD_OUTPUT=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted
