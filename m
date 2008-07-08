Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYGHQwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYGHQwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYGHQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:52:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbYGHQwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:52:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Tue, 8 Jul 2008 18:54:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807081727.40605.rjw@sisk.pl> <Pine.LNX.4.55.0807081646270.27931@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807081646270.27931@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081854.19323.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of July 2008, Maciej W. Rozycki wrote:
> On Tue, 8 Jul 2008, Rafael J. Wysocki wrote:
> 
> > > (B) The current approach to setup timer as ExtINT.
> [...]
> > > (B) ??? who tested this, Rafael
> > 
> > Yes, I tested this.
> 
>  There is some confusion here apparently -- you certainly have not tested
> the timer as an ExtINTA interrupt during the course of this discussion,
> because the "8259A Virtual Wire" through the local APIC has always worked
> for you.  ExtINTA would be the next, fourth and final attempt before a
> panic().

Yes, you're right, sorry.

So in fact I didn't test B.

Thanks,
Rafael
