Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYJGLpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYJGLpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJGLpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:45:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36670 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYJGLpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:45:38 -0400
Date: Tue, 7 Oct 2008 12:45:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081007114500.GA6773@srcf.ucam.org>
References: <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006231002.GN3180@one.firstfloor.org> <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org> <20081007053808.GB20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007053808.GB20740@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 07:38:08AM +0200, Andi Kleen wrote:

> Also calling the workaround a BIOS bug is just unfair in this case. It really
> isn't. 

The BIOS bug in these machines is that they set the thermal trip points 
to 16 degrees C if the APIC is set up in a specific way. It's specific 
to the HPs and it was there in the initial BIOS release - before anyone 
added workarounds for the SB700 issue. It's clearly and unambiguously 
broken, and it's clearly the BIOS's fault. However, it's also clearly 
our responsibility to avoid triggering it on this hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
