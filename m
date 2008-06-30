Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbYF3PgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbYF3PgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762993AbYF3Pfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:35:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56916 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763012AbYF3Pfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:35:33 -0400
Date: Mon, 30 Jun 2008 16:35:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080630153522.GA26185@srcf.ucam.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806292123.16237.rjw@sisk.pl> <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl> <200806300056.16399.rjw@sisk.pl> <Pine.LNX.4.55.0806300003080.22548@cliff.in.clinika.pl> <20080630090607.GA18856@srcf.ucam.org> <Pine.LNX.4.55.0806301607290.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806301607290.30785@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 04:29:33PM +0100, Maciej W. Rozycki wrote:

>  Now I did a search of the Internet and have become puzzled.  Apparently
> there *are* other devices using this DSDT.  See for example a thread at:  
> "http://bbs.archlinux.org/viewtopic.php?pid=359559" where an owner of an
> HP Compaq 6715s has some other problems with a DSDT which coincidentally
> is the very same HP/SB400/10000 (though built with a different ASL
> compiler, hmm...).

Hm. It'd be interesting to know whether the bizarre debug code is in 
there. What's even more interesting is that the 6715s is an SB600, not 
an SB400...

>  Matthew, where did you get these DMI IDs from? -- I cannot see them being 
> reported in any bootstrap log.

dmidecode or /sys/class/dmi. They're not reported on boot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
