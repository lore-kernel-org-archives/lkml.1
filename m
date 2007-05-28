Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXE1CGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXE1CGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXE1CGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:06:35 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:46426 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751725AbXE1CGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:06:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Otr8m80GoM1xSxVFdmquUvUCSdEr1M+XAVWcs+/Al8U8U9rORWe0F69duycgZNuQ8EROWODZ4K8VP2dzObb2DzzrAKnEW70ms2Qf0Ak/ZBpbJGd94B/nzKYB0ICuPKSMIkS7eVYX0jpldLEX2536H5IUk6ZrFTtzFOfFXgIq+ig=  ;
X-YMail-OSG: zqU1OJ4VM1mPhjj70P4v_kL8VCgJMKuJuFcJbFeTuIfSKK5q4i2LJKPithJO3O.F80Ag8LJ.gA--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Date: Sun, 27 May 2007 18:44:49 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070527190351.GA21387@srcf.ucam.org> <20070527233911.GA23491@srcf.ucam.org> <20070528003822.GA23759@srcf.ucam.org>
In-Reply-To: <20070528003822.GA23759@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271844.54589.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007, Matthew Garrett wrote:
> On Mon, May 28, 2007 at 12:39:11AM +0100, Matthew Garrett wrote:
> 
> > but will disable /proc/acpi/wakeup. It'll also be impossible to load 
> > CONFIG_RTC_CMOS because CONFIG_RTC has grabbed the io ports, so it's not 
> > possible to use the new interface. This situation doesn't appear to be 
> > documented, which is less than ideal...
> 
> Actually, it seems to be worse than that - the PNP entry for my cmos 
> clock doesn't appear to mention an irq, so the wakealarm entry doesn't 
> work. I can happily wake it using the /proc/acpi/alarm interface.
> 
> David, would you be happy with hardcoding the rtc-cmos IRQ to 8 on PCs 
> if there's inadequate PNP information available?

That would seem to naturally belong in the PNP code, yes?

Agreed that it seems like it needs to be hardcoded somewhere.

- Dave
