Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYANCEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYANCEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 21:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYANCEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 21:04:01 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:57849 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYANCEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 21:04:00 -0500
Date: Mon, 14 Jan 2008 02:03:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080114020352.GA2502@srcf.ucam.org>
References: <20080112022348.GC27524@khazad-dum.debian.net> <200801120416.08631.lenb@kernel.org> <20080113165801.GA4132@ucw.cz> <20080113234129.GE10693@khazad-dum.debian.net> <20080114003553.GA1698@srcf.ucam.org> <20080114015009.GA2317@srcf.ucam.org> <20080114015718.GA15124@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114015718.GA15124@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 11:57:18PM -0200, Henrique de Moraes Holschuh wrote:
> On Mon, 14 Jan 2008, Matthew Garrett wrote:
> > not going to want the low-level ACPI code to do anything video-related 
> > on a lot of hardware. The in-kernel modesetting code for Intel machines 
> > will be able to handle this significantly more effectively.
> 
> Yeah, but we have a ton of machines (thinkpads among them) with ATI, and
> other GPUs.

The ATI case is certainly more of an issue, but I'm becoming more 
optimistic about that being workable in the near future - certainly on 
machines with ATOM-based BIOSes.
 
> Whitelists would need to be reasonably specific, anyway (not "all
> thinkpads"), so it just means "don't do it on certain R50e", or whatever.

I'd prefer not to push this policy into the kernel, since the right 
thing to do depends on which graphics drivers you're using and so on. 
Userspace is in a better position to make this determination. Of course, 
this also means not passing the Linux OSI to the firmware. Our hardware 
interaction is sufficiently in flux that any attempt to work around it 
in the firmware is just going to lead to bizarre breakage down the road.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
