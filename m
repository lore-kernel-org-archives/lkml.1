Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXJ1Uts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXJ1Uts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXJ1Utl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:49:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXJ1Utk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:49:40 -0400
Date: Sun, 28 Oct 2007 21:49:38 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: No module symbols loaded - kernel modules not enabled.
In-Reply-To: <fg2p69$t4p$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
References: <fg2p69$t4p$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 20:50, Markus Elfring wrote:
>Hello,
>
>I get the following output from the command "head -n 7 /var/log/boot.msg".
>
>Inspecting /boot/System.map-2.6.23.1-default
>Loaded 27483 symbols from /boot/System.map-2.6.23.1-default.
>Symbols match kernel version 2.6.23.
>No module symbols loaded - kernel modules not enabled.
>
>klogd 1.4.1, log source = ksyslog started.
><5>Linux version 2.6.23.1-default (root@Sonne) (gcc version 4.2.1 (SUSE Linux)) #1 SMP
>PREEMPT Sun Oct 28 15:34:56 CET 2007
>
>
>A lot of discussions can be found around this specific notice about symbol loading. I am
>interested in an explanation for the effects on the current kernel.
>Does it just mean that no debugging symbols were loaded?

This message is added by klogd, and it is independent of CONFIG_KALLSYMS.
(Since I do have KALLSYMS=y while also getting that message. I suppose
it is because CONFIG_DEBUG_INFO=n)
