Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZFAAQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZFAAQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZFAAQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:16:34 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:56038 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZFAAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:16:33 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: 2.6.30rc7: ksoftirqd CPU saturation (x86-64 only, not x86-32) (e1000e-related?)
References: <87prdozxns.fsf@hades.wkstn.nix>
	<20090531170350.1355b3f1.akpm@linux-foundation.org>
From: Nix <nix@esperi.org.uk>
Emacs: The Awakening
Date: Mon, 01 Jun 2009 01:16:26 +0100
In-Reply-To: <20090531170350.1355b3f1.akpm@linux-foundation.org> (Andrew Morton's message of "Sun, 31 May 2009 17:03:50 -0700")
Message-ID: <87ljoczu3p.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Jun 2009, Andrew Morton said:

> Let's cc netdev on this.
>
> Presumably it is a post-2.6.29 regression.

I don't know: the earliest kernel this machine has ever run was
2.6.30rc5, and this failing 2.6.30rc7 kernel is the first 64-bit kernel
I've ever run on it. So currently I have one single data point.

I plan to try out 2.6.29 (and back to 2.6.25 or thereabouts) tomorrow
and see if it ever worked: if it did I'll bisect for it (rendered tricky
by the out-of-tree e1000e driver, but doable: it would be easier if I
had a clue where the e1000-devel git tree is, if anywhere, but I still
have no idea despite considerable searching).

It seems to go wrong instantly, so replication is trivial, and this
system can compile a kernel in slightly under a minute, so it shouldn't
take too long to complete the bisection.
