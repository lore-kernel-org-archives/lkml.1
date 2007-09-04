Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXIDQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXIDQH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXIDQHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:07:16 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:34953 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXIDQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:07:15 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 4 Sep 2007 17:05:45 +0100
User-Agent: KMail/1.9.7
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
References: <20070902045634.06ea0515@loke.fish.not> <200709041620.47213.alistair@devzero.co.uk> <200709041626.27945.ak@suse.de>
In-Reply-To: <200709041626.27945.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041705.45670.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 16:26:27 Andi Kleen wrote:
> > Seconded. It's been largely ignored which is annoying because the HPET
> > works perfectly on this board. I assume the reason is still that nobody
> > from NVIDIA verified hardward support for the hack.
>
> It's IMHO a bad idea to add any overrides without access to data sheets
> and errata sheets. The hardware might be broken and do bad
> (subtle) bad things with HPET.  That's not a theoretical case.
> There used to be at least one case where a chipset would occasionally
> destroy the BIOS flash when HPET was force enabled.

I haven't used any CK804 with an HPET which is BIOS enabled by default, so 
it's probably most likely that the reference BIOS didn't enable it.

As this technology is quite antiquated, the usual "well Vista uses HPET, so 
maybe vendors will enable it" probably won't apply. I know for my board, no 
BIOS has been released since early 2006.

> That means for Intel it's fine to do (because errata sheets are public);
> but for Nvidia and VIA it's dangerous and should not be done.

I don't disagree with you and I think you're right in the general case, but 
even if we could pin somebody down from NVIDIA (which is seeming unlikely, 
considering the right people have already been CCed), it would still be a 
BIOS override.

In this case,  there's a perfectly good HPET masked behind what I can only 
speculate is a BIOS misfeature (my kernel's behaved itself with Mikko's patch 
applied and Thomas's HRT patchset on x86-64).

What about an expert option which could force the HPET on (rather than "find" 
and enable it)? Are you opposed to this too?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
