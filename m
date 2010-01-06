Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918Ab0AFOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0AFOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909Ab0AFOtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:49:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58589 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755516Ab0AFOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:49:14 -0500
Date: Wed, 6 Jan 2010 14:51:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, Christian Hofstaedtler <ch@zeha.at>,
       x86@kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100106145106.03031bcd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100106074101.GE1392@ucw.cz>
References: <20100104162114.GA30113@percival.namespace.at>
	<alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
	<20100106074101.GE1392@ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KBD is present on all PCs, not so with acpi. If machine can't handle
> kbd reboot, it is not IBM PC compatible.

Most modern PC systems are not "IBM PC compatible" in various respects.

Defaulting to ACPI reboot is fine as it can fall back to non ACPI reboot
if there is no ACPI or ACPI doesn't provide the needed info for the
system in question
