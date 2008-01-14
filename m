Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYANBua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYANBua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYANBuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:50:19 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:51299 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYANBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:50:18 -0500
Date: Mon, 14 Jan 2008 01:50:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080114015009.GA2317@srcf.ucam.org>
References: <20080112022348.GC27524@khazad-dum.debian.net> <200801120416.08631.lenb@kernel.org> <20080113165801.GA4132@ucw.cz> <20080113234129.GE10693@khazad-dum.debian.net> <20080114003553.GA1698@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114003553.GA1698@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:35:54AM +0000, Matthew Garrett wrote:

> No. This breaks on the R50e, at least - I suspect it'd also have 
> problems on any nvidia based machines, but I don't have one to hand at 
> the moment. It can be set at runtime already.

Just to clarify this further, in the relatively near-term future we're 
not going to want the low-level ACPI code to do anything video-related 
on a lot of hardware. The in-kernel modesetting code for Intel machines 
will be able to handle this significantly more effectively.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
