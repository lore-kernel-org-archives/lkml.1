Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXFUVsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXFUVsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXFUVsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:48:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbXFUVsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:48:22 -0400
Message-ID: <467AF204.3060805@redhat.com>
Date: Thu, 21 Jun 2007 17:47:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: ACPI Regression on Dell E1501
References: <467AE7E1.4050805@canonical.com>
In-Reply-To: <467AE7E1.4050805@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2007 05:04 PM, Tim Gardner wrote:
> Hi,
> 
> Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
> E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
> it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
> X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
> defconfig). No kernel built after this commit works for this platform.
> 
> There is no crash output, it just wedges after 'NET: Registered protocol
> family 2'.
> 
> How can I debug this problem?

That'll be fun.

That's:

	[PATCH] clockevents: i386 drivers

[Author cc: added]
