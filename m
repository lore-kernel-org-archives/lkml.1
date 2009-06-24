Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZFXVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZFXVNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZFXVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:13:35 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:37413 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZFXVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:13:35 -0400
Date: Wed, 24 Jun 2009 17:13:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
In-reply-to: <20090622194303.GC2284@ucw.cz>
Message-id: <alpine.LFD.2.00.0906241645250.20716@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
 <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
 <20090622194303.GC2284@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Pavel Machek wrote:

> On Tue 2009-06-23 14:41:28, Len Brown wrote:

> > Please let me know if your questions are not thoroughly answered here:
> > http://simplefirmware.org/faq
> 
> It really tells us nothing. I don't think flash got so expensive that
> this is justified. ACPI can already do the job, right? and operating
> systems already have to support ACPI. So what are the reasons to
> reinvent the wheel?

The price of flash, and the amount consumed, is not relevent
to the decision whether a platform should support SFI or ACPI.

The Moorestown platform doesn't use ACPI because its chip-set
fundamentally does not support it.  Not only is the required
register set missing, *all* IO accesses are missing, and there is
no SMM support present to emuate it.

Yes, the ACPI specification could have been edited to replace
every "must" with "could", "shall" with "may", and "required" with 
"optional" resulting in "ACPI compliance" for your toaster.
But doing so would have been a dis-service to the
platforms supporting ACPI, and would have made the
already hard job of supporting ACPI from the OS significantly harder.

thanks,
-Len Brown, Intel Open Source Technology Center
