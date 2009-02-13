Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZBMTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZBMTSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZBMTSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:18:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60136 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZBMTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:18:18 -0500
Date: Fri, 13 Feb 2009 19:18:15 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Message-ID: <20090213191815.GB1379@srcf.ucam.org>
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org> <cone.1234551556.57236.4642.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1234551556.57236.4642.1000@onepiie>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 07:59:16PM +0100, Peter Feuerer wrote:
> Matthew Garrett writes:
> >If 
> >these io ports are also used by the firmware then you'll need to find 
> >ACPI methods to call to perform the fan control. 
> 
> I get the temperature by calling ec_read(0x58) and can read/write the state 
> of the fan by ec_write to / ec_read from 0x55. Actually I don't know if 
> those embedded controller registers are used by the firmware. How can I 
> find it out?

Ok, yup, that should be safe. It might be nice to implement this as an 
hwmon driver, potentially tying it into the thermal layer.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
