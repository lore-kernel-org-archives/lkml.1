Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYGGWI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYGGWI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYGGWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:08:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbYGGWIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:08:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Tue, 8 Jul 2008 00:10:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807072231.57925.rjw@sisk.pl> <Pine.LNX.4.55.0807072239170.20615@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807072239170.20615@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080010.42603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Maciej W. Rozycki wrote:
> On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:
> 
> > So I'm going to apply the appended combined patch on top of linux-next and
> > retest.
> 
>  Wonderful!  Thanks for your patience and cooperation.

Unfortunately, it hangs solid very early on boot, before earlyprintk=vga
kicks in.

Thanks,
Rafael
