Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZLCOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZLCOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZLCOzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:55:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34815 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZLCOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:55:14 -0500
Date: Thu, 3 Dec 2009 14:55:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Backlight device class redesign
Message-ID: <20091203145502.GA23212@srcf.ucam.org>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com> <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com> <1259827274.27069.50.camel@rzhang1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259827274.27069.50.camel@rzhang1-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 04:01:14PM +0800, Zhang Rui wrote:

> IMO, we should create one device for one display.
> For example, device /sys/class/backlight/panel0 is created the first
> time a backlight_ops for this display is registered.

For anything other than the simple case (one display per machine), how 
do you know whether the firmware, platform and gpu are referring to the 
same display device?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
