Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbYBSVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbYBSVEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYBSVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:04:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbYBSVEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:04:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Petazzoni <thomas.petazzoni@enix.org>
Subject: Re: arch/x86/kernel/acpi/sleep_32.c not compiled ?
Date: Tue, 19 Feb 2008 22:02:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20080219165940.6e9348f6@crazy>
In-Reply-To: <20080219165940.6e9348f6@crazy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192202.53510.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 of February 2008, Thomas Petazzoni wrote:
> Hi,

Hi,

> Maybe I'm missing something completely obvious, but I don't see where
> the arch/x86/kernel/acpi/sleep_32.c file gets compiled. The Makefile in
> that directory compiles sleep.o, but doesn't compile sleep_$(BITS).o:
> 
> obj-$(CONFIG_ACPI)              += boot.o
> obj-$(CONFIG_ACPI_SLEEP)        += sleep.o wakeup_$(BITS).o
> 
> ifneq ($(CONFIG_ACPI_PROCESSOR),)
> obj-y                           += cstate.o processor.o
> endif

No, the file is not build now.

Pavel, is this file really necessary?

Rafael
