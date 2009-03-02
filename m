Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZCBPHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZCBPHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZCBPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:07:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53253 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZCBPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:07:23 -0500
Date: Mon, 2 Mar 2009 16:10:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
Message-ID: <20090302151007.GM2527@elf.ucw.cz>
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236004310-29196-4-git-send-email-daniel@caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This solves the dependency between lis3lv02d.[ch] and ACPI specific
> methods. It introduces a ->bus_priv pointer to the device struct which
> is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> accordingly.

Looks okay to me. I did the basic split but -- having only single
client -- did not really have motivation to finish it.

> This also moves the read_8() and read_16() routines from hp_accel.c to
> lis3lv02d.c as they are not specific to ACPI.

These would be slightly better done as separate patch, but I guess its okay...

> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
