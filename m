Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0AIRJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0AIRJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 12:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732Ab0AIRJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 12:09:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39608 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0AIRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 12:09:14 -0500
Date: Sat, 9 Jan 2010 17:09:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
	notebooks to enable brightness keys
Message-ID: <20100109170908.GA15755@srcf.ucam.org>
References: <537531092@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537531092@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 04:14:14PM +0100, Peter Paul wrote:
> The brightness control keys (Fn+F7 & Fn+F8) only work when adding this boot parameter.
> They do not create any events for the OS but work even when in BIOS or GRUB, but not in Linux without said kernel parameter.
> Userspace tools are able controlling brightness using standard methods regardless of any ACPI parameters, they only seem to affect the keys themselves.

What do you mean by "work"? Do you get any ACPI interrupts when you hit 
the keys without the override parameter?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
