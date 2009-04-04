Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZDDVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZDDVMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZDDVM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:12:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbZDDVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:12:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergio Luis <sergio@larces.uece.br>
Subject: Re: [PATCH 0/6] x86: unify power/cpu_(32|64).c
Date: Sat, 4 Apr 2009 23:12:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, "x86 Maintainers" <x86@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
References: <49D71E2B.5060501@larces.uece.br>
In-Reply-To: <49D71E2B.5060501@larces.uece.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904042312.46429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009, Sergio Luis wrote:
> This patch series intends to unify the cpu_32.c and cpu_64.c files.
> 
> It's divided into 6 patches, that deal with the following:
> #1 - unify headers
> #2 - unify global variables
> #3 - unify saving of processor state
> #4 - unify restoring of processor state
> #5 - unify copyright notes on the files
> #6 - unify the files themselves, leaving only cpu.c
> 
> The code generated is _exactly_ the same as before, on both  i386 and
> x86-64 architectures, so I don't expect this to introduce _any_ new bugs.
> However, cleanups can be done in future, as for instance, the removal
> of a few global variables in the 32 bit architecture. We are not dealing 
> with those in this series.
> 
> The patches are against 2.6.29.

OK, you can add my ACK to the whole series.

Still, I wouldn't like it to go in before 2.6.30 final, because there are
enough deep changes related to suspend and resume already in the
Linus' tree.

Thanks,
Rafael
