Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYF3JGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYF3JGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYF3JGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:06:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33071 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYF3JGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:06:24 -0400
Date: Mon, 30 Jun 2008 10:06:07 +0100
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
Message-ID: <20080630090607.GA18856@srcf.ucam.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806292123.16237.rjw@sisk.pl> <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl> <200806300056.16399.rjw@sisk.pl> <Pine.LNX.4.55.0806300003080.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806300003080.22548@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:00:04AM +0100, Maciej W. Rozycki wrote:

>  The DSDT is clearly associated with the SB400 southbridge.  I would not
> expect a given make and model to use different southbridges across the
> series, so there will only be one DSDT per model, possibly in a number of
> revisions.  On the other hand different models may use the same
> southbridge and hence the same DSDT.
>
>  Note that Matthew's made a point here, that apparently there are only two 
> models using this southbridge and new ones are unlikely to be released, so 
> my note is for a reference only.

No, there's many other systems using the same southbridge that don't 
have the bizarre DSDT code and so don't show this behaviour.
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
