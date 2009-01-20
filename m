Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZATJTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZATJTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZATJSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:18:48 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:50787 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755071AbZATJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:18:44 -0500
X-Greylist: delayed 1794 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 04:18:44 EST
X-Spam-Virus: No
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc2
X-URL: <http://www.mandrivalinux.com/
References: <alpine.LFD.2.00.0901161244310.4965@localhost.localdomain>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Tue, 20 Jan 2009 09:50:27 +0100
In-Reply-To: <alpine.LFD.2.00.0901161244310.4965@localhost.localdomain> (Linus Torvalds's message of "Fri\, 16 Jan 2009 12\:58\:55 -0800 \(PST\)")
Message-ID: <m2k58q2wfg.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> It's out there now, or at least in the process of mirroring out.
> 
> About half of the bulk is a late MIPS merge (tssk, tssk, but I really 
> couldn't make myself care too much), and there are a few odd new drivers 
> there too. In fact, of the non-MIPS code, drivers is about half of the 
> remaining one, and then firmware (which is really drivers too but shows up 
> separately) is half of _that_ remaining half.
> 
> And there's the system call sign-extension for for the architectures that 
> need it (ppc/64 and s390/64). The rest is really pretty small.
> 
> But despite being small, that's probably more important and noticeable to 
> most people: the first slew of regression fixes. We had non-working 3D 
> acceleration on many machines (no compiz! What shall we do without those 
> wobbly windows!) that should be fixed, and a ton of other irritating 
> issues like that.

Well, "xorg failling to start up" regression fix hasn't yet been
included.
Since 2.6.28, X.org failed to start with SiS video cards due to PAT.
See  http://bugzilla.kernel.org/show_bug.cgi?id=12372
The patch fix hasn't been included neither in RC1 nor in RC2...
