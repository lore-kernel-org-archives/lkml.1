Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbXEaK03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbXEaK03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXEaK0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:26:21 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43485 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbXEaK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:26:20 -0400
Date: Thu, 31 May 2007 11:26:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20070531102603.GA16719@srcf.ucam.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531043229.GA30888@dose.home.local>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RTC_DRV_CMOS can break userspace interface
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:32:29AM +0200, Tino Keitel wrote:

> rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
> rtc_cmos: probe of 00:09 failed with error -16
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

Try unsetting CONFIG_RTC - you can't use the legacy driver at the same 
time as the new one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
