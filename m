Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZBJPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZBJPpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZBJPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:45:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42191 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbZBJPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:45:40 -0500
Date: Tue, 10 Feb 2009 15:45:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
Message-ID: <20090210154533.GA27596@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> <20090210150431.GA26798@srcf.ucam.org> <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 03:15:21PM +0000, Darren Salt wrote:

> As things stand, this is likely to be a problem for anybody using lenny on
> Eee hardware and upgrading (on their own) to 2.6.29, given that that
> workaround is present in eeepc-acpi-scripts in lenny.
> 
> Anyway, removing that option fixes the problem.

Ok. I'll look into ensuring that these don't collide, but fundamentally 
the problem here is distributions using broken options rather than 
fixing the problem properly in the first place.

> > BIOS bug. There's an explicit delay in the eee bios for some reason, and 
> > I haven't found any straightforward way to avoid it.
> 
> BIOS bug or no, the fact remains that this is (AFAICS) a regression.

You don't get properly working hotkeys otherwise, to the best of my 
recollection. There's an entry on the kernel bugzilla about this 
somewhere.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
