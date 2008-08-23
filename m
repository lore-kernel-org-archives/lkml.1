Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYHWRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYHWRKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 13:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYHWRKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 13:10:05 -0400
Received: from main.gmane.org ([80.91.229.2]:34037 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYHWRKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 13:10:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
Date: Sat, 23 Aug 2008 18:58:02 +0200
Message-ID: <874p5bekit.fsf@natisbad.org>
References: <200808231610.46473.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cct.net8.nerim.net
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: 47EB 85FE B99A AB85 FD09 46F3 0255 957C 047A 5026
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:YDlgKPywxSN3/dTjsHQMlYgOCTc=
Cc: linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Michael Buesch <mb@bu3sch.de> writes:

> I am seeing random kernel and userland application
> crashes on a Powerbook running a 2.6.27-rc3 based kernel
> (wireless-testing.git). 
>
> The crashes did recently appear. It might be the case that they were
> introduced with the merge of 2.6.27-rc1 into wireless-testing.
> I'm not sure on that one, however. Just a guess. I still need to
> do more testing (also on vanilla upstream kernels).
>
> The crashes are completely random and they look like bad hardware.
> However I cannot reproduce on 2.6.25.9 (That's a kernel I still had
> installed, so I tried that one). So it most likely is _not_ caused
> by faulty hardware.
>
> The crashes are hard to reproduce, and happen about every 20 minutes
> when compiling a kernel tree. (gcc segfaults). Sometimes the kernel
> oopses in random places with pointer dereference faults.

Exact same thing here on a PB 12" (not a ppc64, but ppc32). It was not
on a wireless-testing.git but on a recent net-2.6 or 2.6.27-rc3 (I do
not remember precisely). I thought it was a thermal issue and did not
spend time on it because of another regression I bisected (sysctl+IPv6)
that version useless for me.

> Is this a known issue?

Now it is ;-)

> I'm going to bisect this one, but it will take a lot of time, as
> reproducing takes about 20 minutes. So that's about an hour for one
> test round.

Thanks for doing that.

Cheers,

a+

