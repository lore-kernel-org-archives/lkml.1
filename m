Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbXBJMb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbXBJMb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbXBJMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:31:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:57966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbXBJMb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:31:28 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/9] Fix HPET init race
Date: Sat, 10 Feb 2007 13:31:01 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070206164459.GA7271@dwarf.suse.cz> <20070206161256.43fd11de.akpm@linux-foundation.org>
In-Reply-To: <20070206161256.43fd11de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101331.02131.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Well it still seems a bit dodgy to me - I'd have thought it'd be possible
> (and nicer) to come up with a version which is safe to call at any time.
> 
> Are you sure this won't cause a kexec'ed kernel to lock up for five
> minutes, for example?
> 
> Anyway, I'll let Andi worry about this one.  Please send him a signed-off
> and fully changelogged patch and still cc myself, thanks.

What is the status on this one? Jiri, do you have an updated patch?
-Andi
