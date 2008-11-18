Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYKRRRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYKRRRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYKRROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:14:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54720 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYKRROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:14:23 -0500
Date: Tue, 18 Nov 2008 17:14:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Vul <andrey.vul@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how to show ACPI key events
Message-ID: <20081118171417.GA1295@srcf.ucam.org>
References: <e38d12ff0811171736h1238ee6at4bafe06dafff6378@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38d12ff0811171736h1238ee6at4bafe06dafff6378@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 08:36:02PM -0500, Andrey Vul wrote:
> I hacked atkbd.c to dump every keycode and enabled CONFIG_EVBUG yet
> the Fn+F{1..12} and Fn+{arrow} keys don't register an event. Is there
> a way to hack the ACPI drivers to dump keycodes?
> 
> From hacking at the Windows drivers, pressing the hotkeys generates an
> acpi event. How do I get the acpi key events dumped?

If there's a driver for your machine, acpidump or just watch 
/proc/acpi/events (and then port the driver to create an input device 
and use that instead). If there's no existing driver, you get to write 
one. There's no standard spec for sending hotkeys over ACPI, other than 
sleep, power and lid.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
