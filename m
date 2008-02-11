Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYBKP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYBKP4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYBKP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:56:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:46249 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753929AbYBKP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:56:36 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1+ScbkPOTOSsaQm3yOhVqxcQbd10cC3WBR2436XHx
	PB4BiqQqosYw+x
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       Ray Lee <ray.lee@tapsys.com>
Cc: Pavel Machek <pavel@suse.cz>, Len Brown <len.brown@intel.com>
In-Reply-To: <200802101954.31061.rjw@sisk.pl>
References: <1202664109.8394.19.camel@mtlp> <200802101954.31061.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 16:56:26 +0100
Message-Id: <1202745386.7382.23.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of February 2008, Rafaek J. Wysocki wrote:

> Can you apply the appended patch on top of the current mainline and tetest?
> 
> Thanks,
> Rafael
> 

Sorry, that doesn't fix it. 
But I'm pretty sure it is related to that commit. Bisecting went
straight forward to it and reverting it fixes the bug. 

@Ray
I'm not sure you have the same problem. After waking up from s2ram, only
my fan runs at highest speed and keeps on, at least for half an hour.
All other acpi-related stuff works as usual. No sign of a stuck
ACPI-system.

Thanks,
Mirco

