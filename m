Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYALPwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYALPwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYALPvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:51:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52992 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613AbYALPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:51:52 -0500
Date: Sat, 12 Jan 2008 15:49:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080112154916.6bca2395@lxorguk.ukuu.org.uk>
In-Reply-To: <20080112022348.GC27524@khazad-dum.debian.net>
References: <20080112022348.GC27524@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, what should we do about it?  Add a quirk to always define the Linux OSI
> string on ThinkPads (based on DMI information)?  All IBM ones (which won't
> have BIOS revisions anymore, anyway) deal well with it, and Lenovo ones
> seem to benefit from it.

If Lenovo systems do the right thing then I guess submit a patch which
checks for a DMI identifier string for Lenovo and if so don't lie to the
ACPI interpreter.

Alan
