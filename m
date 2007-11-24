Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXKXE2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXKXE2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKXE1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:27:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:59156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXKXE1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:27:51 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22] i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
Date: Fri, 23 Nov 2007 23:27:33 -0500
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <47001841.1000107@users.sourceforge.net> <20071020183309.GB11373@elf.ucw.cz> <471B1F44.5050801@users.sourceforge.net>
In-Reply-To: <471B1F44.5050801@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711232327.33622.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007 05:43, legolas558@users.sourceforge.net wrote:

> I have emerged lm_sensors but can't get it running - it keeps saying "No
> sensors found!" and complaining about kernel drivers not properly setup.
> I have attached the output of sensors-detect, from which it seems that
> the kernel is OK.

In this case, getting sensors installed is the opposite of what you want to do.
The idea is to simplify the system until it works, then figure out what
simplification made it work.

ie. disable sensors entirely by building a kernel with CONFIG_HWMON=n

If that makes things work, then it is a clue.
If that was disabled already, then just keep it disabled.

cheers,
-Len

