Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYFQVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYFQVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYFQVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:37:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbYFQVhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:37:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Tue, 17 Jun 2008 23:38:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806172259.47861.rjw@sisk.pl> <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806172338.38318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 of June 2008, Maciej W. Rozycki wrote:
> On Tue, 17 Jun 2008, Rafael J. Wysocki wrote:
> 
> > May I gently ask that the patch ("x86: I/O APIC: timer through 8259A second-chance")
> > be reverted?
> 
>  We're trying to find a solution for a long-standing problem and this
> patch is a step in that direction.  We need to find out exactly what is
> going wrong with the HP nx6325 system and removing the patch would make us
> lose the opportunity to get things right in this area.  At the time I
> submitted that patch I warned a lot of testing would be required before it
> goes upstream and hopefully my request will get honored.  If you do not
> want to participate in testing for whatever reason, you have the right to
> do so, but I insist on the patch to stay at least until we know the source
> of the problem and conclude there is no other way to get it fixed.  Len
> reported he's got the same system and it behaves the same, so I hope he'll
> be able to do the testing if you decide to opt out.

I can do the testing actually, but IMO putting that patch into linux-next was a
mistake.

>  Unfortunately the 64-bit variation has a lot of necessary logging
> disabled by default (as you have now discovered with the need to rename
> apic_printk() to printk()), so my plan is to cook up a patch to enable all
> the available logging facilities around that code first.

Well, that's easy.  I can send you a dmesg output with all of the printk()s in
there functional if that helps, but frankly I don't see how this is going to
get you more information than I've already posted.

Thanks,
Rafael
