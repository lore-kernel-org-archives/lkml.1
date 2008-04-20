Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYDTKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYDTKBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYDTKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:01:37 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:41176 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721AbYDTKBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:01:37 -0400
Date: Sun, 20 Apr 2008 10:33:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rumi Szabolcs <rumi_ml@rtfm.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dying hdd causing MCE and panic (libata)
Message-ID: <20080420103358.028c94e2@the-village.bc.nu>
In-Reply-To: <20080420113309.2343eb63.rumi_ml@rtfm.hu>
References: <20080420113309.2343eb63.rumi_ml@rtfm.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Is it normal that a simple hard disk failure (that is not even
> the system disk) causes MCEs and kernel panics?

No but with old style (pre AHCI) IDE it can because the system may MCE if
the CPU<->Disk hangs. If a drive is causing PSU problems it could also
occur I guess - ditto heat. You'd need to decode the MCE

> - Is this a problem that is induced completely on the hardware
> level (eg. the southbridge going crazy and making the whole
> hardware platform unstable) or a problem that could be fixed
> or handled properly on the software (kernel) level?

An MCE the hardware can recover from is reported and we continue. CPU
Context Corrupt means the processor internally set a "cannot carry on"
indicator.

Alan
