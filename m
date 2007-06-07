Return-Path: <linux-kernel-owner+w=401wt.eu-S966027AbXFGTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966027AbXFGTtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965195AbXFGTte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:49:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965143AbXFGTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:49:33 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706041013.49428.rjw@sisk.pl>
	<87hcpnpt4k.fsf@goat.bogus.local> <200706042302.45628.rjw@sisk.pl>
Date: Thu, 07 Jun 2007 21:50:28 +0200
In-Reply-To: <200706042302.45628.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 4 Jun 2007 23:02:45 +0200")
Message-ID: <87y7ivo86z.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18YAmC4BZzi7dg7Kj/dzzyrpmsaGKkGgOgUpHc
 bQ/0PAtSSe0FSVU2ga44x2Z+gAK1BNV9GekIpdLeA08nv2OWm7
 02avAZWIFqQwIhVC+WKMg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> You may try to use 's2ram --force --vbe_post --vbe_mode', if you haven't tried
> that already.

Unfortunately, this doesn't work either.

> Still, if the card is a 7300 or higher, that need not work (at present we don't
> know what magic is required to make these cards work).

It's a GeForce 6600 Go. Anyway, you were right with your assumption.

I installed the nvidia.ko (1.0-9755) kernel module and now the machine
comes back to life. Although the screen stays black as before, I can
type blindly "shutdown -r now" or ssh into the laptop.

Regards, Olaf.
