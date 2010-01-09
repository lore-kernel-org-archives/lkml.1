Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481Ab0AIWGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0AIWGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321Ab0AIWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:06:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36089 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab0AIWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:06:11 -0500
Date: Sat, 9 Jan 2010 22:06:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
	notebooks to enable brightness keys
Message-ID: <20100109220606.GA19441@srcf.ucam.org>
References: <539929391@web.de> <20100109202642.GA18657@srcf.ucam.org> <1263073701.6497.75.camel@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263073701.6497.75.camel@rechenknecht2k7>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 10:48:21PM +0100, Peter Paul wrote:

> /proc/interrupts does change all the time
> The only backlight related interrupt seems to be IO-APIC-fasteoi (9) - I
> get 5-7 interrupts there when pressing either Fn+F8 (brightness down) or
> Fn+F7 (brightness up), but only when brightness has not reached a
> maximim level in the direction I want to go.

Ok, so there's an ACPI event generated when you hit the keys. Can you 
please run the acpidump command as root and send me the output?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
