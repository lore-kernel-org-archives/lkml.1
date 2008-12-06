Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYLFNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYLFNhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 08:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYLFNh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 08:37:29 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:33641 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbYLFNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 08:37:29 -0500
From: Frans Pop <elendil@planet.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ohci1394: "irq 19: nobody cared" during resume from suspend to ram
Date: Sat, 6 Dec 2008 14:37:24 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net,
       Jarod Wilson <jwilson@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200812061316.38460.elendil@planet.nl> <493A79FE.1050403@s5r6.in-berlin.de>
In-Reply-To: <493A79FE.1050403@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061437.25977.elendil@planet.nl>
X-OriginalArrivalTime: 06 Dec 2008 13:37:26.0763 (UTC) FILETIME=[C70FDBB0:01C957A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008, Stefan Richter wrote:
> drivers/ieee1394/ohci1394.c and drivers/firewire/fw-ohci.c are
> different beasts.  Your dmesg shows the former to be active.  Please
> check.

Oops. Thanks for the correction.

That actually makes more sense as ohci1394.c currently does not call 
free_irq during suspend. I'll see if I can come up with something for 
that driver.
