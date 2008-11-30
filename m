Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbYK3FDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbYK3FDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 00:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYK3FDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 00:03:41 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:42424 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYK3FDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 00:03:40 -0500
Date: Sun, 30 Nov 2008 00:03:19 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
In-reply-to: <200810252004.01274.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, fabio.comolli@gmail.com
Message-id: <alpine.LFD.2.00.0811292351580.3239@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>
 <200810252004.01274.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The underlying issue is we've never reported such BIOS bugs before and now we
> do that unconditionally.  IMnshO, this should only be done if ACPI debugging is
> enabled.
> 
> While I can see a value in doing that always, IMO such a change should only be
> made after a big announcement.

I agree that we were aggressive in shipping this checking in 2.6.28-rc.

The checking has no functional effect, except to issue a console warning,
so I figured it had limited down-side.

It actually paid off almost immediately by pointing out why
a Linux bug was provoked on jejb's test box.

I had figured on making it CONFIG_ACPI_DEBUG for the
final release, but at this point we've seen only the
_BIF and _WAK warnings -- and they're both dealt with
via the patches queued for Linus.

So at this point, I'm inclined to keep this checking enabled in
2.6.28-final, independent of CONFIG_ACPI_DEBUG.

-Len



